var ProjectNames;

var xmlProcessor = "C:\\Program Files\\Altova\\AltovaXML2012\\AltovaXML.exe"

var xmlFolder;
var resultFolder;
var templatesFolder;
var xsltFolder;

var shell = new ActiveXObject("WScript.Shell");
var fso = new ActiveXObject("Scripting.FileSystemObject");

var xmlTOC = new ActiveXObject("Microsoft.XMLDOM")
var xslTOC = new ActiveXObject("Microsoft.XMLDOM")

function Log(aMessage) {
//  now = new Date()
//  datedMessage = LeadZero(now.getDate()) + '-' + LeadZero(now.getMonth()) + '-' + now.getYear() + ' ' + LeadZero(now.getHours()) + ':' + LeadZero(now.getMinutes()) + ':' + LeadZero(now.getSeconds()) + ' ' + aMessage
//  WScript.Echo(datedMessage)
  WScript.Echo(aMessage)
//  oLog.WriteLine(datedMessage);
}

function sDOS2Win(sText, bInsideOut) {
  var aCharsets = ["windows-1251", "cp866"];
  sText += "";
  bInsideOut = bInsideOut ? 1 : 0;
  with (new ActiveXObject("ADODB.Stream")) { //http://www.w3schools.com/ado/ado_ref_stream.asp
    type = 2; //Binary 1, Text 2 (default) 
    mode = 3; //Permissions have not been set 0,  Read-only 1,  Write-only 2,  Read-write 3,  
    //Prevent other read 4,  Prevent other write 8,  Prevent other open 12,  Allow others all 16
    charset = aCharsets[bInsideOut];
    open();
    writeText(sText);
    position = 0;
    charset = aCharsets[1 - bInsideOut];
    return readText();
  }
}

function Exec(aStartMessage, aCommand) {
  Log(aStartMessage)
  Log('< ' + aCommand)
  try {
    oExec = shell.Exec(aCommand)
    oStdOut = oExec.StdOut
    oStdErr = oExec.StdErr

    while (!oStdOut.AtEndOfStream) {
      Log('> ' + sDOS2Win(oStdOut.ReadLine(), 0))
    }
    while (!oStdErr.AtEndOfStream) {
      Log('> ' + sDOS2Win(oStdErr.ReadLine(), 0))
    }
    if (oExec.ExitCode != 0) {
      Log('Execution failed')
      return false
    }
  }
  catch(e) {
    Log('Error: ' + e.message)
    return false
  }
  return true
}



function processUnit(aUnitName, aTOC) {
  file = fso.OpenTextFile(xmlFolder + '\\' + aUnitName + '.xml', 1)
  xmldata = file.ReadAll();
  file.Close();

  file = fso.OpenTextFile(xmlFolder + '\\' + aUnitName + '.xml', 2);
  file.WriteLine(xmldata.replace('type=bullet"', 'type="bullet"').replace('type=number"', 'type="number"').replace('type=table"', 'type="table"'));
  file.Close();


  res = Exec('Processing unit ' + aUnitName, xmlProcessor + ' /xslt2 ' + xsltFolder + '\\namespace.xslt /in ' + xmlFolder + '\\' + aUnitName + '.xml /out ' +  resultFolder + '\\' + aUnitName + '.html /xparam doc-title="NEXSTEP.CIS.Classes"');
  if (res)
    res = Exec('Generating TOC for unit ' + aUnitName, xmlProcessor + ' /xslt2 ' + xsltFolder + '\\namespace-toc.xslt /in ' + xmlFolder + '\\' + aUnitName + '.xml /out ' +  'toc' + '.xml /xparam doc-title="NEXSTEP.CIS.Classes"');
  if (res) {
    w = xmlTOC.createElement('OBJECT')
    param = xmlTOC.createElement('param')
    param.setAttribute('name', 'Name');
    param.setAttribute('value', aUnitName);
    w.appendChild(param);

    param = xmlTOC.createElement('param')
    param.setAttribute('name', 'Local');
    param.setAttribute('value', aUnitName + '.html');
    w.appendChild(param);

    l = xmlTOC.createElement('LI')
    l.appendChild(w);
    aTOC.appendChild(l)

    var unitTOC = new ActiveXObject("Microsoft.XMLDOM")
    unitTOC.load('toc.xml');
    aTOC.appendChild(unitTOC.documentElement.cloneNode(true));
    unitTOC = null;
    file = fso.GetFile('toc.xml');
    file.Delete();
  }
  return res;
}

function processProject(aProjectName, aTOC) {
  proj = new ActiveXObject("Microsoft.XMLDOM");
  proj.async = false;
  proj.load(xmlFolder + '\\' + aProjectName + '.xml');
  if(proj.readyState == 4) {
    lUnitsList = proj.selectNodes("//namespace/contains")

    l = xmlTOC.createElement('LI')
    w = xmlTOC.createElement('OBJECT')

    param = xmlTOC.createElement('param')
    param.setAttribute('name', 'Name');
    param.setAttribute('value', aProjectName);
    w.appendChild(param);

    param = xmlTOC.createElement('param')
    param.setAttribute('name', 'Local');
    param.setAttribute('value', aProjectName + '.html');
    w.appendChild(param);

    l.appendChild(w);

    aTOC.appendChild(l)
    z = xmlTOC.createElement('UL');
    aTOC.appendChild(z)
    
    for(var i = 0; i < lUnitsList.length; i++) {
      if (!processUnit(lUnitsList[i].attributes.getNamedItem("name").value, z))
        return false;
    }
  }
  return Exec('Processing project ' + aProjectName, xmlProcessor + ' /xslt2 ' + xsltFolder + '\\project.xslt /in ' + xmlFolder + '\\' + aProjectName + '.xml /out ' +  resultFolder + '\\' + aProjectName + '.html /xparam doc-title="NEXSTEP.CIS.Classes"');
}

function processProjects() {
  var item = xmlTOC.appendChild(xmlTOC.createElement('UL'));  
  for(var i = 0; i < ProjectNames.length; i++) {
    if (!processProject(ProjectNames[i], item)) 
      return false;
  }
  return true;
}

if (WScript.Arguments.length < 3) {
  Log('Wrong argument count!');
  Log('USAGE: cscript.exe start.js <XMLPATH> <HTMLPATH> <PROJECTS>');
  Log('  <PROJECTS> - comma separated list of projects');
  Log('  <XMLPATH> <HTMLPATH> - without trailing slash!');
  WScript.Quit();
}

ProjectNames = WScript.Arguments(0).split(',');
xmlFolder = WScript.Arguments(1);
resultFolder = WScript.Arguments(2);

scriptFolder = fso.GetFile(WScript.ScriptFullName).ParentFolder;
templatesFolder = scriptFolder + '\\templates';
xsltFolder = scriptFolder + '\\xslt';

Log('Source folder: ' + xmlFolder);
Log('Destination folder: ' + resultFolder);
Log('Templates folder: ' + templatesFolder);
Log('XSLT folder: ' + xsltFolder);
                                  

if (fso.FolderExists(resultFolder)) {
  folder = fso.GetFolder(resultFolder);
  folder.Delete(true);
}

folder = fso.GetFolder(templatesFolder);
folder.Copy(resultFolder, true);

xslTOC.async = false;
xslTOC.load(xsltFolder + '\\htmlcontents.xslt');

processProjects();

var file = fso.CreateTextFile(resultFolder + '\\' + "contents.html", true, false);
file.Write (xmlTOC.transformNode(xslTOC));
file.Close();
