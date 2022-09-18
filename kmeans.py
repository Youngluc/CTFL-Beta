from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import matplotlib.image as imgplt
import numpy as np
from sklearn.metrics import normalized_mutual_info_score,adjusted_rand_score
import os
import pandas as pd
from sklearn.utils.linear_assignment_ import linear_assignment
from PIL import Image

from config import load_args
import torch
import torch.nn as nn
import model
import torchvision.transforms as T


class Downstream(nn.Module):
    def __init__(self, backbone):
        super().__init__()
        self.backbone = backbone
    
    def forward(self, x):
        out = self.backbone(x).squeeze()

        return out


def cluster_acc(y_true, y_pred):

    y_true = np.array(y_true).astype(np.int64)
    assert y_pred.size == y_true.size
    D = max(y_pred.max(), y_true.max()) + 1
    w = np.zeros((D, D), dtype=np.int64)
    for i in range(y_pred.size):
        w[y_pred[i], y_true[i]] += 1
    ind = linear_assignment(w.max() - w)
    return sum([w[i, j] for i, j in ind]) * 1.0 / y_pred.size

    
def getinfo():
    trans = T.Compose([T.Resize((224, 224)), T.ToTensor(), T.Normalize((0.4914, 0.4822, 0.4465), (0.2023, 0.1994, 0.2010))])
    simsiam = model.Model(args)
    obj = torch.load('./checkpoints/epoch800_checkpoint_pretrain_model_bs64.pth')
    simsiam.load_state_dict(obj['model_state_dict'])
    m = Downstream(simsiam.backbone)
    m.eval()
    # 获取文件并构成向量
    #预测值为1维，把一张图片的三维压成1维，那么n张图片就是二维
    global total_photo
    global total_out
    file = os.listdir('./test/-2dB')
    i = 0
    for subfile in file:
        photo = os.listdir('./test/8dB/' + subfile)  #文件路径自己改
        for name in photo:
            photo_name.append('./test/8dB/' + subfile+'/'+name)
            target.append(i)
        i += 1
    for path in photo_name:
        photo = imgplt.imread(path)
        photo = photo.reshape(1, -1)
        photo = pd.DataFrame(photo)
        total_photo = total_photo.append(photo, ignore_index=True)
        img1 = Image.open(path).convert('RGB')
        img1 = trans(img1)
        img1 = img1.unsqueeze(0)
        r = m(img1).cpu()
        out = r.detach().numpy().reshape(1, -1)
        out = pd.DataFrame(out)
        total_out = total_out.append(out, ignore_index=True)
    total_out = total_out.values
    total_photo = total_photo.values


def kmeans():
    clf = KMeans(n_clusters=6)
    clf.fit(total_photo)
    y_predict = clf.predict(total_photo)
    centers = clf.cluster_centers_
    result = centers[y_predict]
    result = result * 255
    result = result.astype("int64")
    #result = result.reshape(1200, 128, 128, 3)#图像的矩阵大小为200,180,3
    return result,y_predict

def kmeans_repr():
    clf = KMeans(n_clusters=6)
    clf.fit(total_out)
    y_predict = clf.predict(total_out)
    centers = clf.cluster_centers_
    return y_predict
        

def draw():
    fig,ax  = plt.subplots(nrows=10,ncols=20,sharex = True,sharey = True,figsize = [15,8],dpi = 80)
    plt.subplots_adjust(wspace = 0,hspace = 0)
    count = 0
    for i in range(10):
        for j in range(20):
            ax[i,j].imshow(result[count])
            count += 1

    plt.xticks([])
    plt.yticks([])
    plt.show()
def score():
    ACC = cluster_acc(target, y_predict)  # y 真实值 y_predict 预测值
    NMI = normalized_mutual_info_score(target, y_predict)
    ARI = adjusted_rand_score(target, y_predict)
    print(" ACC = ", ACC)
    print(" NMI = ", NMI)
    print(" ARI = ", ARI)

    print("line-----line")
    ACC = cluster_acc(target, y_re)  # y 真实值 y_predict 预测值
    NMI = normalized_mutual_info_score(target, y_re)
    ARI = adjusted_rand_score(target, y_re)
    print(" ACC = ", ACC)
    print(" NMI = ", NMI)
    print(" ARI = ", ARI)

if __name__ == '__main__':
    args = load_args()
    photo_name = []
    target = []
    total_photo = pd.DataFrame()
    total_out = pd.DataFrame()
    getinfo()
    result,y_predict = kmeans()
    y_re = kmeans_repr()
    score()
    #draw()

