const express = require('express')
const request = require('request')

const app = express()
const port = 3000
const path = process.env.DNS;

app.get('/', (req, res) => {

  // The frontend greets with the following:
  const message = "Hello from the frontend..."

  // The backend should greet us with "Hello from the backend."
  request(path, (err, response, body) => {
    // We send both greetings together on a GET request to /
    console.log("ERROR MEEAGE" + err);
    console.log("RESPONCE MESSEAGE" + response);
    res.send(message + " " + body);
  })
})

app.listen(port, () => console.log(`Frontend app listening on port ${port} And PATH is ${path}.`))
