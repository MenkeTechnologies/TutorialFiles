#!/usr/bin/env ruby
#created by JAKOBMENKE --> Tue May  2 10:46:03 EDT 2017

# numbers = [1,2,3,4,53]

# numbers.each_with_index do |item, index|
# 	puts "index is #{index} and item is #{item}"
# end

# (0..5).each_with_index do |item, index|
# 	puts
# end

# (0..5).each do |i|
# 	puts i
# end

# begin
# 	answer = 5/0
# rescue
# 	puts "no"
# end

# def check_age(age)
# 	raise ArgumentError, "Enter pos" unless age > 0		
# end

# begin
# 	check_age(-1)
# rescue ArgumentError
# 	puts "error"
# end

# puts "add them #{4 + 5}"

# multi_line = <<EOM
# dogs ArgumentError
# cool
# EOM

# puts multi_line

# str = "dogs are cool"

# puts str.lstrip

# puts str.ljust(20, '.')

# str.delete('a')

# class Animal
# 	def initialize
# 		puts "initing"
# 	end

# 	def set_name(new_name)
# 		@name = new_name
# 	end

# 	def get_name
# 		@name
# 	end
# end

# cat = Animal.new

# cat.set_name("peekaboo")

# puts cat.get_name

# class Dog < Animal
# 	attr_accessor :name, :height, :weight

# 	def bark
# 		"barking"
# 	end
# end

# rover = Dog.new

# rover.set_name("rover")
# rover.name = "rudy"

# puts rover.get_name

# puts rover.bark

# require_relative "human"

# class Tomm
# 	include Human

# 	def act_smart
# 		"smart ..."
# 	end
# end

# jon = Tomm.new

# jon.name = "cool"

# p jon.act_smart

# puts jon.name

# (0..5).each do |i|
# 	jon.run
# end

# class Bird
# 	def tweet(bird_type)
# 		puts "calling super"
# 		bird_type.tweet
# 	end
# end

# class Cardinal < Bird
# 	def tweet
# 		puts 'tweet'
# 	end
# end

# class Parrot < Bird
# 	def tweet
# 		puts "squack"
# 	end
# end

# generic_bird = Bird.new

# generic_bird.tweet(Cardinal.new)

# generic_bird.tweet(Parrot.new)

# :derek

# puts :derek
# puts :derek.to_s
# puts :derek.class

# puts :derek.object_id

# array_1 = [1,2,3,4]

# array_1.unshift(35)

# puts array_1[2,2].join", "

# puts array_1.empty?

# puts array_1.values_at(0,2,3).join(", ")

# puts "array size: " + array_1.size.to_s

# array_1.each do |i|
# 	puts i
# end

# number_hash = {"pi" => 3.14, "gold" => 1.53}

# h2ash = Hash["dogs","rudy"]

# puts h2ash["dogs"] = "flash"

# samp_hash = Hash.new("no key")

# puts samp_hash["dogs"]

# arr = `env`.split("\n")

# newhash = Hash.new("no")

# arr.each do |item|
# 	key, value = item.split("=")
# 	newhash[key] = value
# end

# newhash.each do |key, value|
# 	puts "the key is #{key} and value is #{value}"
# end

class Calculator < Object

	def get_name
		@name
	end

	def initialize(name)
	
		@name = name
		
	end

	def set_name(name)
		@name = name
	end

	def add(a,b)
		return a + b
	end
end

# c = Calculator.new"dogs"

# puts c.get_name

# puts "ruby is cool".match(/ ./)

# 5.times do
# 	puts "cool"
# end

# x = [2,3,5]

# puts x.delete_if{|i| i < 4}

# student = {
# 	"Jacob" => 10,
# 	"jill" => 12,
# 	"bob" => 14
# }

# student["jill"] = 155

# puts student["jill"]

# chuck = Hash[:punch, 99, :kick, 98]

# puts chuck[:punch]

# def artax
# 	a = [:punch, 0]
# 	b = [:kick, 72]
# 	c = []

# end

# class Rectangle
# 	def initialize(length, breadth)
# 		@length = length
# 		@breadth = breadth
# 	end
# 	def perimiter
# 		2*(@length + @breadth)
# 	end
# end

# r = Rectangle.new(2,35)

# def meth

# end

# p r.perimiter

# def sum (*numbers)
# 	numbers.inject(0) { |sum, number| sum + number  }

# 	numbers.each do |i|
# 		p i
# 	end
# end

# p sum(2,35,6,3)

# def substract(num1,num2)

# 	num1 - num2
# end

# l = lambda { "do or do not" }

# l = lambda do |str|
# 	if str == "try"
# 		p 'no such thin'
# 	end
# end

# incr = lambda { |a| a +=1  }

# p incr.call(2)

# def demo_block(number)
# 	yield (number)
# end

# p demo_block(1){ |number| number + 1}

# module WarmUp
# 	def push_ups
# 		"phew"
# 	end
# end

# class Gym
# 	include WarmUp

# 	def preacher
# 		"building biceps"
# 	end
# end

# puts Gym.new.push_ups

# p `pwd`

# l = lambda { |a| a+= 1  }

# p l(1)

# module Perimeter
# 	class Array
# 		def initialize(size)
# 			@size = size
# 		end

# 		def get_size
# 			@size+2
# 		end
# 	end
# end

# module Dojo
# 	A = 4
# 	module Kata
# 		B = 8
		
# 		module Roulette
# 			class ScopeIn
# 				def printer

# 					Dojo::A
# 				end
# 				def push
# 					15
# 				end
# 			end
# 		end
# 	end
# end

# p Dojo::Kata::Roulette::ScopeIn.new.printer

# module Name
# 	Str = File.open("/etc/passwd").read
# end

# puts Name::Str
