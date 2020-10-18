import cv2
import os
import numpy as np
from skimage.filters import gaussian
from .test import evaluate
import argparse
from PIL import Image
from PIL.ExifTags import TAGS
# from google.colab.patches import cv2_imshow



def parse_args():
	parse = argparse.ArgumentParser()
	parse.add_argument('--img-path', default='imgs/116.jpg')
	return parse.parse_args()

def exif_remover(img):
	img_exif = img.getexif()
	if img_exif:
		for key,value in img._getexif().items():
			if TAGS.get(key) == 'Orientation':
				orientation = value
				if orientation == 1:
					return img 
				if orientation == 3:
					img = img.rotate(180)
					return img
				if orientation == 6:
					img = img.rotate(270)
					return img
				if orientation == 8:
					img= img.rotate(90)
					return img
	else:
		return img


def resizer(img,max_size):
	if img.height > max_size or img.width > max_size:
		# if width > height:
		if img.width > img.height:
			desired_width = max_size
			desired_height = img.height / (img.width/max_size)
				
		# if height > width:
		elif img.height > img.width:
			desired_height = max_size
			desired_width = img.width / (img.height/max_size)
				
		else:
			desired_height = max_size
			desired_width = max_size
				
		# convert back to integer
		desired_height = int(desired_height)
		desired_width = int(desired_width)
				
		return img.resize((desired_width, desired_height))

	else:
		return img

def sharpen(img):
	img = img * 1.0
	gauss_out = gaussian(img, sigma=5, multichannel=True)

	alpha = 1.5
	img_out = (img - gauss_out) * alpha + img

	img_out = img_out / 255.0

	mask_1 = img_out < 0
	mask_2 = img_out > 1

	img_out = img_out * (1 - mask_1)
	img_out = img_out * (1 - mask_2) + mask_2
	img_out = np.clip(img_out, 0, 1)
	img_out = img_out * 255
	return np.array(img_out, dtype=np.uint8)


def hair(image, parsing, part=17, color=[ 255,0,0]):
	b, g, r = color      #[10, 50, 250]       # [10, 250, 10]
	print("b: ", b)
	print("g: ", g)
	print("r: ", r)
	tar_color = np.zeros_like(image)
	tar_color[:, :, 0] = b
	tar_color[:, :, 1] = g
	tar_color[:, :, 2] = r

	image_hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
	tar_hsv = cv2.cvtColor(tar_color, cv2.COLOR_BGR2HSV)

	if part == 12 or part == 13:
		image_hsv[:, :, 0:2] = tar_hsv[:, :, 0:2]
	else:
		# image_hsv[:, :, 0:1] = tar_hsv[:, :, 0:1]
		image_hsv[:, :, 0:2] = tar_hsv[:, :, 0:2]

	cv2.imwrite('C:/Users/StudyPC/example/test/image_hsv_2.jpg', image_hsv)

	changed = cv2.cvtColor(image_hsv, cv2.COLOR_HSV2BGR)

	if part == 17:
		changed = sharpen(changed)

	
	# image= cv2.resize(image, (512, 512))
	# changed = cv2.resize(changed,(512,512))
	changed[parsing != part] = image[parsing != part]
	# print (changed)
	# print (image)
	return changed


if __name__ == '__main__':
	# 1  face
	# 11 teeth
	# 12 upper lip
	# 13 lower lip
	# 17 hair

	args = parse_args()

	table = {
		'hair': 17,
		'upper_lip': 12,
		'lower_lip': 13
	}

	image_path = args.img_path
	cp = 'cp/79999_iter.pth'
	# cp = 'cp/20_0.7278_G.pth'


	im = Image.open(image_path)
	image_path = os.path.split(image_path)
	image_path = os.path.join(image_path[0], 'new'+image_path[1])
	im = exif_remover(im)
	# im = resizer(im, 512)
	im.save(image_path)


	image = cv2.imread(image_path)
	# image= cv2.resize(image, (512, 512))
	ori = image.copy()
	parsing = evaluate(image_path, cp)
	# parsing = cv2.resize(parsing, image.shape[0:2], interpolation=cv2.INTER_NEAREST)

	# parts = [table['hair'], table['upper_lip'], table['lower_lip']]
	parts = [table['hair']]
	# parts = [table['lower_lip']]

	colors = [[ 255,0,0], [24, 224, 13], [24, 224, 13]]

	for part, color in zip(parts, colors):
		image = hair(image, parsing, part, color)

		cv2.imwrite('new_makeup.png',image)   
		# cv2_imshow(image)
		# cv2.waitKey(0)
		# cv2.destroyAllWindows()
