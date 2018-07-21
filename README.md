# Gigo

Quickly spin up black-box unit tests for legacy code.

## The problem

You are responsible for some legacy code. The code likely interacts with an API. The code is tangled and has no unit tests, but you still have to maintain it.

Unit tests would help a great deal with this task, but to write the tests is a burden.

## The solution

Gigo will automatically generate "black box" ("characterisation") tests.

The idea is that:

* A given input to the system under test will result in given calls to other systems (APIs);

* Those other systems will respond with their output, which can be mocked;

* When those mocks come back, the system under test will process them to provide its own output, about which we can make assertions.

*These tests assume that the current behaviour of the system is correct.*

When you have these black-box tests, you are testing that the system behaves the same as it did when the tests were generated. This gives you the liberty to maintain the system and ensure that you aren't altering the previous behaviour.