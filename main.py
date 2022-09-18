import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.utils.data.dataloader import DataLoader
from dataset import MyDataset

from config import load_args
from model import Model, DownStreamModel

import os
import matplotlib.pyplot as plt

epochs = []
acc_train = []
acc_test = []

def save_checkpoint(model, optimizer, args, epoch):
    print('\nModel Saving...')
    if args.device_num > 1:
        model_state_dict = model.module.state_dict()
    else:
        model_state_dict = model.state_dict()

    torch.save({
        'model_state_dict': model_state_dict,
        'global_epoch': epoch,
        'optimizer_state_dict': optimizer.state_dict(),
    }, os.path.join('checkpoints', 'epoch'+str(epoch)+'_checkpoint_pretrain_model_bs128.pth'))


def pre_train(epoch, train_loader, model, optimizer, args, f):
    model.train()

    losses, step = 0., 0.
    for x1, x2 in train_loader:
        if args.cuda:
            x1, x2 = x1.cuda(), x2.cuda()

        d1, d2 = model(x1, x2)
        optimizer.zero_grad()
        loss = d1 + d2
        loss.backward()
        optimizer.step()
        losses += loss.item()

        step += 1

    print('[Epoch: {0:4d}, loss: {1:.3f}'.format(epoch, losses / step), file = f)
    return losses / step


def _train(epoch, train_loader, model, optimizer, criterion, args):
    model.train()
    losses, acc, step, total = 0., 0., 0., 0.
    for data, target in train_loader:
        if args.cuda:
            data, target = data.cuda(), target.cuda()

        logits = model(data)

        optimizer.zero_grad()
        loss = criterion(logits, target)
        loss.backward()
        losses += loss.item()
        optimizer.step()

        pred = F.softmax(logits, dim=-1).max(-1)[1]
        acc += pred.eq(target).sum().item()

        step += 1
        total += target.size(0)
    print('[Down Task Train Epoch: {0:4d}], loss: {1:.3f}, acc: {2:.3f}'.format(epoch, losses / step, acc / total * 100.))


def _eval(epoch, test_loader, model, criterion, args):
    model.eval()
    losses, acc, step, total = 0., 0., 0., 0.
    with torch.no_grad():
        for data, target in test_loader:
            if args.cuda:
                data, target = data.cuda(), target.cuda()

            logits = model(data)
            loss = criterion(logits, target)
            losses += loss.item()
            pred = F.softmax(logits, dim=-1).max(-1)[1]
            acc += pred.eq(target).sum().item()

            step += 1
            total += target.size(0)
        print('[Down Task Test Epoch: {0:4d}], loss: {1:.3f}, acc: {2:.3f}'.format(epoch, losses / step, acc / total * 100.))


def train_eval_down_task(down_model, down_train_loader, down_test_loader, args):
    global epochs
    down_optimizer = optim.SGD(down_model.parameters(), lr=args.down_lr, weight_decay=args.weight_decay, momentum=args.momentum)
    down_criterion = nn.CrossEntropyLoss()
    down_lr_scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(down_optimizer, T_max=args.down_epochs)
    for epoch in range(1, args.down_epochs + 1):
        epochs.append(epoch)
        _train(epoch, down_train_loader, down_model, down_optimizer, down_criterion, args)
        _eval(epoch, down_test_loader, down_model, down_criterion, args)
        down_lr_scheduler.step()


def main(args):
    args.checkpoints = 'F:\\PythonProject\\Pytorch\\SimSiam\\checkpoints\\checkpoint_pretrain_model.pth'
    if not os.path.isdir('checkpoints'):
        os.mkdir('checkpoints')
    log = open('log.txt', 'w+')
    model = Model(args)
    #down_model = DownStreamModel(args)
    if args.cuda:
        model = model.cuda()
        #down_model = down_model.cuda()
    
    data = MyDataset("./material")
    trainloader = DataLoader(data, batch_size=16, shuffle=True, drop_last=True, num_workers=4)

    if args.pretrain:
        print("pretrain", file = log)
        log.flush()
        optimizer = optim.SGD(model.parameters(), lr=args.lr, weight_decay=args.weight_decay, momentum=args.momentum)
        lr_scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=800)

        for epoch in range(1, args.epochs + 1):
            train_loss = pre_train(epoch, trainloader, model, optimizer, args, log)
            if epoch % args.print_intervals == 0:
                save_checkpoint(model, optimizer, args, epoch)
            lr_scheduler.step()
            print('Cur lr: {0:.5f}'.format(lr_scheduler.get_last_lr()[0]), file = log)
            log.flush()

if __name__ == '__main__':
    args = load_args()
    main(args)
