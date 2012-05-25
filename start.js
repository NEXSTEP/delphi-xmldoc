var ProjectNames;

var xmlFolder;
var resultFolder;
var templatesFolder;
var xsltFolder;

var shell = new ActiveXObject("WScript.Shell");
var fso = new ActiveXObject("Scripting.FileSystemObject");
var altEngine = new ActiveXObject("AltovaXML.Application")

var xmlTOC = new ActiveXObject("Microsoft.XMLDOM")
var xslTOC = new ActiveXObject("Microsoft.XMLDOM")

function Log(aMessage) {
//  now = new Date()
//  datedMessage = LeadZero(now.getDate()) + '-' + LeadZero(now.getMonth()) + '-' + now.getYear() + ' ' + LeadZero(now.getHours()) + ':' + LeadZero(now.getMinutes()) + ':' + LeadZero(now.getSeconds()) + ' ' + aMessage
//  WScript.Echo(datedMessage)
  WScript.Echo(aMessage)
//  oLog.WriteLine(datedMessage);
}

function processUnit(aUnitName, aTOC) {
  file = fso.OpenTextFile(xmlFolder + '\\' + aUnitName + '.xml', 1)
  xmldata = file.ReadAll();
  file.Close();

  file = fso.OpenTextFile(xmlFolder + '\\' + aUnitName + '.xml', 2);
  file.WriteLine(xmldata.replace('type=bullet"', 'type="bullet"').replace('type=number"', 'type="number"').replace('type=table"', 'type="table"'));
  file.Close();


  Log('* unit ' + aUnitName)
  altEngine.XSLT2.XSLFileName = xsltFolder + '\\namespace.xslt';
  altEngine.XSLT2.InputXMLFileName = xmlFolder + '\\' + aUnitName + '.xml';

  altEngine.XSLT2.Execute(resultFolder + '\\' + aUnitName + '.html'); 

  altEngine.XSLT2.XSLFileName = xsltFolder + '\\namespace-toc.xslt';
  altEngine.XSLT2.InputXMLFileName = xmlFolder + '\\' + aUnitName + '.xml';
  altEngine.XSLT2.Execute(fso.GetSpecialFolder(2) + 'toc.xml'); 

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
  unitTOC.load(fso.GetSpecialFolder(2) + 'toc.xml');
  aTOC.appendChild(unitTOC.documentElement.cloneNode(true));
  unitTOC = null;
  file = fso.GetFile(fso.GetSpecialFolder(2) + 'toc.xml');
  file.Delete();

  return true;
}

function processProject(aProjectName, aTOC) {
  Log('*** Project ' + aProjectName + ' ***********************************');
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

  altEngine.XSLT2.XSLFileName = xsltFolder + '\\project.xslt';
  altEngine.XSLT2.InputXMLFileName = xmlFolder + '\\' + aProjectName + '.xml';
  try {
    altEngine.XSLT2.Execute(resultFolder + '\\' + aProjectName + '.html'); 
  } catch(err)  {
    Log( "Error:", altEngine.XSLT2.LastErrorMessage);
    return false;
  };

  return true;
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

scriptFolder = fso.GetFile(WScript.ScriptFullName).ParentFolder;

ProjectNames = WScript.Arguments(0).split(',');
xmlFolder = WScript.Arguments(1).replace(/\\$/, '').replace(/^.\\/, scriptFolder + '\\');
resultFolder = WScript.Arguments(2).replace(/\\$/, '').replace(/^.\\/, scriptFolder + '\\');


templatesFolder = scriptFolder + '\\templates';
xsltFolder = scriptFolder + '\\xslt';

Log('Source folder: ' + xmlFolder);
Log('Destination folder: ' + resultFolder);
Log('Templates folder: ' + templatesFolder);
Log('XSLT folder: ' + xsltFolder);
Log('');

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
