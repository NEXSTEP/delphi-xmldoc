var projectName;

var xmlFolder;
var resultFolder;
var templatesFolder;
var xsltFolder;

var fso = new ActiveXObject("Scripting.FileSystemObject");
var altEngine = new ActiveXObject("AltovaXML.Application")

function Log(aText) {
  WScript.Echo(aText);
}

if (WScript.Arguments.length != 2) {
  Log('Wrong argument count!');
  Log('USAGE: cscript.exe start.js <XMLPATH> <HTMLPATH> <PROJECTS>');
  Log('  <PROJECTS> - file name of xml with project list (must be placed in dirs with all other xml\'s)');
  Log('  <HTMLPATH> - path where generated docs will be placed');
  WScript.Quit();
}

scriptFolder = fso.GetFile(WScript.ScriptFullName).ParentFolder;

projectName = WScript.Arguments(0).replace(/^.\\/, scriptFolder + '\\');
xmlFolder = projectName.replace(/.[^\\]*$/, '');
resultFolder = WScript.Arguments(1).replace(/\\$/, '').replace(/^.\\/, scriptFolder + '\\');
templatesFolder = scriptFolder + '\\templates';
xsltFolder = scriptFolder + '\\xslt';

Log('Project file: ' + projectName);
Log('Source folder: ' + xmlFolder);
Log('Destination folder: ' + resultFolder);
Log('Templates folder: ' + templatesFolder);
Log('XSLT folder: ' + xsltFolder);
Log('');

Log('Clearing destination folder...')
if (fso.FolderExists(resultFolder)) {
  folder = fso.GetFolder(resultFolder);
  folder.Delete(true);
}

Log('Copy templates to destination...')
folder = fso.GetFolder(templatesFolder);
folder.Copy(resultFolder, true);

Log('Fixing list bug...')
f = fso.GetFolder(xmlFolder);
fc = new Enumerator(f.files);
for (; !fc.atEnd(); fc.moveNext())
{
  if (fc.item().size != 0) {
    file = fso.OpenTextFile(fc.item(), 1)
    xmldata = file.ReadAll();
    file.Close();
    file = fso.OpenTextFile(fc.item(), 2);
    file.WriteLine(xmldata.replace(/type=bullet"/gi, 'type="bullet"').replace(/type=number"/gi, 'type="number"').replace(/type=table"/gi, 'type="table"').replace(/<\s*paramref\s+name=(.+)\s*\/\s*>/gi, '"$1"'));
    file.Close();
  }
}

Log('Generating htmls...');
altEngine.XSLT2.XSLFileName = xsltFolder + '\\contents.xslt';
altEngine.XSLT2.InputXMLFileName = projectName;
altEngine.XSLT2.Execute(resultFolder + '\\contents.html'); 