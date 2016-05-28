{
  start = {
    text = "Hello, %name. This is just a test conversation"
    choices = {{text = "greet", next_conversation = "next_talk"},
      {text = "bye", next_conversation = "end"}
    },
  next_talk = {
    text = {"This is supposed to be one text",
      "And this text should appear on a new window"}
    choices = {
      {text = "end conversation", next_conversation = "end"},
      {text = "special option", next_conversation = "start", conditions = {test_condition} }
    }
  }
}