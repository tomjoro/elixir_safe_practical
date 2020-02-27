package main

import (
	"fmt"
	"time"
)

func f1(from string) {
	for i := 0; i < 100000; i++ {
		fmt.Println(from, ":", i)
	}
}

// Try commenting the fmt.Println, what happens?
func f2(from string) {
	i := 0
	for {
		fmt.Println(from, ":", i)
		i++
	}
}

func main() {

	//f1("direct")

	go f1("1 goroutine")
	go f2("2 goroutine")

	go func(msg string) {
		fmt.Println(msg)
	}("going")

	time.Sleep(time.Second * 5)
	fmt.Println("done")
}
