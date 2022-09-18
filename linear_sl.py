import torch
import torch.nn as nn
import torchvision
import torchvision.transforms as T
import torchvision.models as rmodels
import torchvision.datasets as datasets
from torch.utils.data.dataloader import DataLoader
import datetime
import sys

from config import load_args

import numpy as np

import model


class Downstream(nn.Module):
    def __init__(self, backbone, evalLinear):
        super().__init__()
        self.backbone = backbone
        self.evalLinear = evalLinear
        # for name, param in self.backbone.named_parameters():
        #     param.requires_grad = False
    
    def forward(self, x):
        out = self.backbone(x).squeeze()
        out = self.evalLinear(out)
        return out


class Flatten(nn.Module):
    def __init__(self):
        super().__init__()
    
    def forward(self, x):
        return x.squeeze()

class MLP(nn.Module):
    def __init__(self, inputsize, nclass, hidden = 0):
        super().__init__()
        if hidden:
            self.net = nn.Sequential(
                nn.Linear(inputsize, hidden),
                nn.BatchNorm1d(hidden),
                nn.ReLU(inplace=True),
                nn.Linear(hidden, nclass),
            )
        else:
            self.net = nn.Linear(inputsize, nclass)
    
    def forward(self, x):
        return self.net(x)


def train_one_epoch(Trainloader, model, optimizer, epoch, criterion, f):
    model.train()
    for images, labels in Trainloader:
        images, labels = images.cuda(), labels.cuda()
        output = model(images)
        loss = criterion(output, labels)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
    print('Epoch [{}/{}], Loss: {:.4f}'.format(epoch+1, 300, loss.item()), file = f)
    f.flush()


def test(Testloader, model, f):
    model.eval()
    with torch.no_grad():
        correct = 0
        total = 0
        for images, labels in Testloader:
            images, labels = images.cuda(), labels.cuda()
            outputs = model(images)
            predicted = torch.argmax(outputs, dim=1)
            total += labels.size(0)
            correct += (predicted == labels).sum()
        print('Accuracy of the model on the 300 test images: {} %'.format(100 * correct / total), file = f)
        f.flush()


def main(args):
    device = torch.device('cuda:0') 
    trans = T.Compose([T.Resize((224, 224)), T.ToTensor(), T.Normalize((0.4914, 0.4822, 0.4465), (0.2023, 0.1994, 0.2010))])
    noise = args.noise
    if noise.startswith('n'):
        noise = '-' + noise[1:]
    log = open(args.log, 'w+')
    Train = datasets.ImageFolder('./eval/'+noise, transform=trans)
    Test = datasets.ImageFolder('./test/'+noise, transform=trans)
    Traindata = DataLoader(Train, batch_size=16, shuffle=True, num_workers=2)
    Testdata = DataLoader(Test, batch_size=300, shuffle=True, num_workers=2)

    simsiam = model.Model(args)
    obj = torch.load('./checkpoints/epoch800_checkpoint_pretrain_model_bs128.pth')
    simsiam.load_state_dict(obj['model_state_dict'])

    resnet50 = rmodels.resnet50(pretrained=False)
    resnet_model = nn.Sequential(*list(resnet50.children())[:-1])

    evalheader = MLP(2048, 6, 2048)
    f = Flatten()
    #models = Downstream(nn.Sequential(simsiam.backbone), evalheader)
    models = Downstream(resnet_model, evalheader)
    models = models.to(device)
    criterion = nn.CrossEntropyLoss()  
    optimizer = torch.optim.SGD(models.parameters(), lr=args.down_lr, weight_decay=args.weight_decay, momentum=args.momentum) 
    # args.down_epochs = 1
    for epoch in range(0, args.down_epochs):
        train_one_epoch(Traindata, models, optimizer, epoch, criterion, log)
        test(Testdata, models, log)


def img():
    trans = T.Compose([T.Resize((224, 224)), T.ToTensor(), T.Normalize((0.4914, 0.4822, 0.4465), (0.2023, 0.1994, 0.2010))])
    Train = datasets.ImageFolder('./eval/-6dB', transform=trans)
    #Test = datasets.ImageFolder('./test/-6dB', transform=trans)
    Traindata = DataLoader(Train, batch_size=200, shuffle=True, num_workers=2)
    print(Train.class_to_idx)

if __name__ == '__main__':
    args = load_args()
    main(args)