const cp = require("child_process");

cp.spawn("bash", ["list.sh"], { stdio: "inherit" });
