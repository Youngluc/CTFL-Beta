import argparse


def load_args():
    parser = argparse.ArgumentParser()

    # Pre training
    parser.add_argument('--base_dir', type=str, default='./data/cifar-10-batches-py')
    parser.add_argument('--img_size', type=int, default=224)
    parser.add_argument('--batch_size', type=int, default=512)
    parser.add_argument('--num_workers', type=int, default=4)
    parser.add_argument('--cuda', type=bool, default=True)
    parser.add_argument('--epochs', type=int, default=800)
    parser.add_argument('--lr', type=float, default=0.01)
    parser.add_argument('--momentum', type=float, default=0.9)
    parser.add_argument('--weight_decay', type=float, default=1e-4)
    parser.add_argument('--checkpoints', type=str, default=None)
    parser.add_argument('--pretrain', action='store_true', default=False)
    parser.add_argument('--device_num', type=int, default=1)
    parser.add_argument('--print_intervals', type=int, default=20)

    # Network
    parser.add_argument('--proj_hidden', type=int, default=4096)
    parser.add_argument('--proj_out', type=int, default=2048)
    parser.add_argument('--pred_hidden', type=int, default=2048)
    parser.add_argument('--pred_out', type=int, default=2048)

    # Down Stream Task
    parser.add_argument('--down_lr', type=float, default=0.01)
    parser.add_argument('--down_epochs', type=int, default=300)
    parser.add_argument('--down_batch_size', type=int, default=256)

    parser.add_argument('--noise', type=str, default='0dB')
    parser.add_argument('--log', type=str, default='log_0dB_ssl.txt')

    args = parser.parse_args()

    return args
