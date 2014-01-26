## Todo
1. Branch
2. REPL
3. Test harness

1. Take stock and assess handler implementation
2. Don't muck around with a TCP server
3. Build a test suite to test:
  a. Handler dispatch
  b. Individual handlers
4. Make it single user
5. Build a REPL

## Keep
- Handler structure
- Dispatch/frecency mechanism
- Chain of responsibility

## Think about
1. Neat way to terminate the chain, i.e. set a message as completed

## Flow
1. Client loads library, library loads all handlers and connects to db
2. Client must register to recieve output
3. Client sends Message Object to Handler
4. All clients receive Message Objects at end
5. Client handles message to best of ability.

## How can we test handlers?
  Send a message to the queue
  Check that desired message is returned
  For each test suite
    Set up the Handler dispatch with only one handler
    Assert that desired message is returned

Should really be a library for dispatching messages to successive
handlers

## Message object attributes
- Message
- Source
- Handled
- Force Output?
