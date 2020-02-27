package main

import (
	"fmt"
	"time"
)

type field struct {
	name string
}

func (p *field) print() {
	fmt.Println(p.name)
}
func main() {
	data := []field{{"one"}, {"two"}, {"three"}}
	for _, v := range data {
		time.Sleep(time.Second)
		go v.print()
	}
	<-time.After(1 * time.Second)
}

//why does this code print "two" "two" "three"
