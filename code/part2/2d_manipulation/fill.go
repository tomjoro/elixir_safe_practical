package main

// This routine produces two image (from imput jpg and raw)
//  1. The color encoded depth with clipping starting from "nose" in RGBA
//				-> outputs "image.png"
//	2. A depth image Gray16 with filling
//				--> outputs a base64 string with encoded depth

import (
	"encoding/binary"
	"fmt"
	"log"
	"os"
	"time"

	// Package image/jpeg is not used explicitly in the code below,
	// but is imported for its initialization side-effect, which allows
	// image.Decode to understand JPEG formatted images. Uncomment these
	// two lines to also understand GIF and PNG images:
	// _ "image/gif"
	// _ "image/png"

	_ "image/jpeg"
)

func main() {
	for i := 0; i < 10000; i++ {
		doit()
	}
}
func doit() {
	initWidth := 1000
	start := time.Now()

	//fmt.Print("Decode the raw data now\n")
	//file, err := os.Open("../testdata/depth.raw")
	file, err := os.Open("big.raw")
	if err != nil {
		log.Fatal(err)
	}

	width := initWidth
	height := initWidth
	pixels := width * height

	//fmt.Printf("The image is %d x %d - pixels: %d\n", width, height, pixels)

	//
	// Create the output array
	//
	outputSlice := make([]uint16, pixels) //output
	slice := make([]uint16, pixels)
	fillValue := uint16(0)
	var pixelcolor = uint16(0)

	err = binary.Read(file, binary.LittleEndian, slice)
	file.Close()
	if err != nil {
		log.Fatal(err)
	}

	// We could do it inplace - i guess?

	for x := 0; x < width-1; x++ {
		fillValue = 0 // reset the scanning at each line
		for y := height - 1; y >= 0; y-- {
			// pixel is
			pixelcolor = slice[y*width+x] // this is a value

			// find the current runValue
			if pixelcolor != 0 {
				fillValue = pixelcolor
			}
			if pixelcolor == 0 && fillValue != 0 {
				pixelcolor = fillValue
			}

			outputSlice[y*width+x] = pixelcolor
		}
	}

	//fmt.Printf("Length of array read: %d\n", len(outputSlice))

	//fmt.Printf("% s\n", encoded)
	f, _ := os.Create("./output.raw")
	binary.Write(f, binary.LittleEndian, outputSlice)
	f.Close()

	elapsed := time.Since(start)

	//fmt.Println("\nAll done")
	//if elapsed > 10000000 {
	fmt.Printf("Time took %d\n", elapsed)
	//}
	// seems to be about 20ms
}
