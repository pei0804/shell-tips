#!/bin/bash

greet()
{
  echo "Hello"
}

greet

greet2()
{
  echo $1 "Hello"
}

greet2 A
