package main

import "core:fmt"
import "core:crypto/hash"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"
import "core:image"
import "core:image/netpbm"



sha1_tras_proc :: proc(input:string) -> [25]image.RGB_Pixel{
	// Compute the digest, using the low level API.
	ctx: hash.Context
	digest := make([]byte, hash.DIGEST_SIZES[hash.Algorithm.Insecure_SHA1])
	defer delete(digest)

	hash.init(&ctx, hash.Algorithm.Insecure_SHA1)
	hash.update(&ctx, transmute([]byte)input)
	hash.final(&ctx, digest)

  seq := make([]u8, len(digest))
	for i in 0..<len(digest) {
		a:u8 = digest[i]
    seq[i] = a

	} 

  return myxor(seq)
}

md5_tras_proc :: proc(input:string) -> [25]image.RGB_Pixel{
	// Compute the digest, using the low level API.
	ctx: hash.Context
	digest := make([]byte, hash.DIGEST_SIZES[hash.Algorithm.Insecure_MD5])
	defer delete(digest)

	hash.init(&ctx, hash.Algorithm.Insecure_MD5)
	hash.update(&ctx, transmute([]byte)input)
	hash.final(&ctx, digest)

  seq := make([]u8, len(digest))
	for i in 0..<len(digest) {
		a:u8 = digest[i]
    seq[i] = a

	} 

  return myxor(seq)
 
}
xor_to_img_proc :: proc(st:[]int)-> [25]image.RGB_Pixel{
    d :int= 1
    row:int= 0
    mp:[25]image.RGB_Pixel
    rgb:image.RGB_Pixel

    for m in st{
      if(d <26){
      if(m%2 == 1){
        fmt.printf(" 0   0   0 ")
        rgb = {0,0,0}
      }else{
      
        fmt.printf(" 255 255 255 ")
        rgb = {0xff,0xff,0xff}
      }
      mp[d-1] = rgb
      fmt.printf(" ")
      if(d%5==0){
        fmt.printf("\n")
        row+=1
      }
    }
      d+=1
    }
    return mp

}

myxor :: proc(s:[]u8) -> [25]image.RGB_Pixel {
  
  size:int = len(s)
  st:string = fmt.aprintf("%x",s)
  
  st,_= strings.remove_all(st,", ")
  st,_= strings.remove_all(st,"]")
  st,_= strings.remove_all(st,"[")
  mxor := make([]int, 5*5)

  for i in 0..<5{
      mxor[i*5]  ,_ = strconv.parse_int(utf8.rune_string_at_pos(st,0+3*i),base=16)
      mxor[i*5+1],_ = strconv.parse_int(utf8.rune_string_at_pos(st,1+3*i),base=16)
      mxor[i*5+2],_ = strconv.parse_int(utf8.rune_string_at_pos(st,2+3*i),base=16)
      mxor[i*5+3],_ = strconv.parse_int(utf8.rune_string_at_pos(st,1+3*i),base=16)
      mxor[i*5+4],_ = strconv.parse_int(utf8.rune_string_at_pos(st,0+3*i),base=16)
  }
    return xor_to_img_proc(mxor)

}

main :: proc() {
 

  my_header :image.Netpbm_Header = 
    {
      format = image.Netpbm_Format.P3,
      width = 5, 
      height = 5,
      channels = 3,
      maxval = 255
    }
  my_info:image.Netpbm_Info = {header = my_header}

  mhead:image.Image_Metadata 
  mhead = &my_info
  input := "hediinn"
  mpix:[25]image.RGB_Pixel = md5_tras_proc(input)
  fmt.printf("\n")
  im,b:=image.pixels_to_image(pixels = mpix[:], width =5, height = 5)
  fmt.printf("%v\n",b)
  im.metadata = mhead
  netpbm.save_to_file("a.bmp",&im)

  //xor_to_img_proc(md5_tras_proc(input))

}
