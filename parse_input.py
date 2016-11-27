import numpy as np
import sys

class Domainset:
    def __init__(self,setname, window = 1, one_hot = True):
        self.train = Dataset();
        self.test = Dataset();
        if setname == "DSP":
            for i in range(1,6): #1:5
                filename = "./dsp_hw1/seq_model_0%d.txt" %i;
                data = ReadDSPData(filename,window);
                if(one_hot):                    
                    labels = np.zeros( (np.shape(data)[0],5) );
                    labels[:,i-1] = 1;
                else:
                    labels = np.ones( (np.shape(data)[0],1) )*i;
                
                self.train.append(data,labels);
            data = ReadDSPData( "./dsp_hw1/testing_data1.txt",window);
            labels = ReadDSPLabels("./dsp_hw1/testing_answer.txt");
            self.test.append(data,labels);
        
class Dataset:
    def __init__(self):
        self.data = np.array([]);
        self.labels = np.array([]);
        self.current_id = 0;
        self.data_num = 0;
        self.perm_ids = np.array([]);

    def append(self,data,label):
        self.data = np.vstack( (self.data,data) ) if self.data.size else data
        self.labels = np.vstack( (self.labels,label) ) if self.labels.size else label
        self.data_num = np.shape(self.data)[0];
        self.perm_ids = np.random.permutation(self.data_num)
        
    def next_batch(self,batch_size):
        if(self.current_id + batch_size > self.data_num ):
            self.current_id = 0;
            self.perm_ids = np.random.permutation(self.data_num);
        batch_xs = self.data[self.perm_ids[self.current_id:self.current_id+batch_size],];
        batch_ys = self.labels[self.perm_ids[self.current_id:self.current_id+batch_size]];
        self.current_id = self.current_id + batch_size;       
        return batch_xs, batch_ys

            
def ReadDSPData(filename,window = 1):    
    char_map = {"A":1,"B":2,"C":3,"D":4,"E":5,"F":6};
    with open(filename) as f:
        arr = list();
        for line in f:
            l = list();
            for ch in line:
                if(ch in char_map):
                    l.append(char_map[ch]);
            l_win = list();
            for w in range(len(l) - window+1):
                l_win.append(l[w:w+window])
            arr.append(l_win);
        return(np.array(arr))

def ReadDSPLabels(filename,one_hot = True):
    with open(filename) as f:        
        arr = list();
        if one_hot:
            for line in f:
                l = np.zeros(5);
                l[int(line[7])-1] = 1;
                arr.append(l);
            arr = np.array(arr);
        else:
            for line in f:
                arr.append(float(line[7]))
            arr =  np.array(arr).reshape(-1,1)
        return arr
    

if __name__ == "__main__":
    dsp = Domainset("DSP");    
    print(dsp.train.data)
    print(dsp.train.labels)
    print(dsp.test.data)
    print(dsp.test.labels)
#    data = ReadFile(sys.argv[1])
#    print(data)
