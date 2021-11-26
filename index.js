const emoji = require('node-emoji')
const fs = require('fs')
const inquirer = require('inquirer')
const config = require('./config')
const series = require('async.series')


var exec = require('child_process').exec;
const command = (cmd, dir, cb) => {
  exec(cmd, {
    cwd: dir || __dirname
  }, function(err, stdout, stderr) {
    if (err) {
      console.error(err, stdout, stderr);
    }
    cb(err, stdout.split('\n').join(''), stderr);
  });
};

const tasks = [];

['brew', 'npm', 'mas'].forEach( type => {
  if(config[type] && config[type].length){
    tasks.push((cb)=>{
      console.info(emoji.get('coffee'), ' installing '+type+' packages')
      cb()
    })
    config[type].forEach((item)=>{
      tasks.push((cb)=>{
        console.info(type+':', item)
        command('. lib_sh/echos.sh && . lib_sh/requirers.sh && require_'+type+' ' + item, __dirname, function(err, stdout, stderr) {
          if(err) console.error(emoji.get('fire'), err, stderr)
          cb()
        })
      })
    })
  }else{
    tasks.push((cb)=>{
      console.info(emoji.get('coffee'), type+' has no packages')
      cb()
    })
  }
})
series(tasks, function(err, results) {
  console.log('package install complete')
})
