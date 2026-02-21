import hashlib
import random
from pathlib import Path

_DEBUG:bool = False

def b16i(s:str)->int:
    assert(len(s)==1)
    return int(s,base=16)

def myxor(s:str):
    halfsize = len(s)-6
    halfsize = halfsize//2
    newvars:list= []
    if(_DEBUG):
        print_p_len(s)
    if(halfsize > 14):
        half1 = s[:halfsize]
        half2 = s[halfsize:len(s)-6]
        if(_DEBUG):
            print_p_len(half1)
            print_p_len(half2)
        for x,y in zip(half1,half2):
            v =b16i(x)^b16i(y)
            newvars.append(v)
    else:
        if(_DEBUG):
            print_p_len(s)
        for x in s:
            v = b16i(x)
            newvars.append(v)



    new_array = []
    for i in range(5):
        new_array.append(newvars[0+3*i])
        new_array.append(newvars[1+3*i])
        new_array.append(newvars[2+3*i])
        new_array.append(newvars[1+3*i])
        new_array.append(newvars[0+3*i])
    return new_array

def print_p_len(s:str):
    print(f"{s} : {len(s)}")


def img_withAlg(ass:str,filename:str):
    print(filename)
    xora = myxor(ass)
    r,g,b = [ass[-6:-4],ass[-4:-2],ass[-2:]]
    d = 1
    row = 0

    with open(filename,"w") as f:
        f.write("P3\n5 5\n255\n")

        for i in xora:
            if(d <26):
                if(i%2 == 1):
                    f.write(f"{int(r,base=16)} {int(g,base=16)} {int(b,base=16)}")
                else:
                    f.write(f"255 255 255")
                f.write(" ")

                if(d%4==0):
                    f.write("\n")
                    row+=1
            else:
                continue
            d+=1 
            

class Avatar:
    _name:str
    bytesOfName:bytes 
    def __init__(self,name:str) -> None:
        self._name = name
        self.bytesOfName = bytes([ord(char) for char in name])
        if(Path(name).exists() is False):
            Path(name).mkdir()


    def sha256_img(self):
        sha256_m = hashlib.sha256(self.bytesOfName)
        a = sha256_m.hexdigest()
        img_withAlg(a,f"{self._name}/sha256.bmp")
   
    def md5_img(self):  
        md5_m = hashlib.md5(self.bytesOfName)
        a = md5_m.hexdigest()
        img_withAlg(a,f"{self._name}/md5.bmp")

    def sha1(self):  
        sha1_m = hashlib.sha1(self.bytesOfName)
        a = sha1_m.hexdigest()
        img_withAlg(a,f"{self._name}/sha1.bmp")

    def sha384(self):  
        m = hashlib.sha384(self.bytesOfName)
        a = m.hexdigest()
        img_withAlg(a,f"{self._name}/sha384.bmp")
    def sha3_512(self):  
        m = hashlib.sha3_512(self.bytesOfName)
        a = m.hexdigest()
        img_withAlg(a,f"{self._name}/sha3_512.bmp")


   



if __name__ == "__main__":
    names = ["hediinn", "zombie","hediin"]
    avatars:list[Avatar] = []
    for name in names:
        avatars.append(Avatar(name))

    for av in avatars:
        av.sha384()
        av.sha3_512()
        av.sha1()

