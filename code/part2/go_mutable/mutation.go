package main

import (
	"fmt"
)

type dummyStruct struct {
	a int
}

func (m *dummyStruct) doSomethingElse() {
	fmt.Println(m.a)
	m.a = 44
}
func (m *dummyStruct) doSomething() int {
	/* do a bunch of stuff */
	go func() {
		m.a = 33
		m.doSomethingElse()
	}()
	return 3
}

func main() {
	m := &dummyStruct{}
	for {
		m.a = 22
		m.doSomething()
	}
}
