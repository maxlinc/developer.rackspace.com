  
 ..codeblock:: nodejs
 
  rackspace.deleteRecord(myZone, myRec, function (err){
    if (err) {
      console.dir(err);
      return;
    }
    console.log('DNS Record was successfully deleted.');
  });