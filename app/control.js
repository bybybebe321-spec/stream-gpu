const http = require("http");
const { spawn } = require("child_process");

const TOKEN = process.env.CONTROL_TOKEN || "secret";

function run(cmd) {
  return spawn("supervisorctl", ["start", cmd], { stdio: "inherit" });
}

const server = http.createServer((req, res) => {
  if (req.headers.authorization !== `Bearer ${TOKEN}`) {
    res.writeHead(401);
    return res.end("unauthorized");
  }

  if (req.url === "/start" && req.method === "POST") {
    run("browser");
    run("controller");
    run("ffmpeg");
    res.end("started");
  } else {
    res.writeHead(404);
    res.end();
  }
});

server.listen(7070, () => console.log("Control API on 7070"));
