var Ansible = require('node-ansible');
var command = new Ansible.Playbook();

  var product = process.argv[2];
  var nodeEnv = process.argv[3];
  var environment = process.argv[4];
  var version = process.argv[5];
  var playbook = process.argv[6];
  var engineVersion;
  if (process.argv.length > 7)
    engineVersion = process.argv[7];


command.playbook('/opt/ansible/'+ playbook +'');
command.inventory('/opt/ansible/inventories/' + product + '-' + environment);
var extraVars = {version: version, nodeEnv: nodeEnv, environment: environment};
if (engineVersion) {
  extraVars.engineVersion = engineVersion;
}
command.variables(extraVars);
command.on('stdout', function(data) { console.log(data.toString()); });
command.on('stderr', function(data) { console.log(data.toString()); });
var promise = command.exec({cwd:"/opt/ansible/"});
promise.then(function(result) {
  console.log("return code: ", result.code);
}, function (err){
  console.error(err);
});
