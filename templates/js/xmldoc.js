var L_SeeAlso_TEXT = "See Also"

function resizeBan(){
//resizes nonscrolling banner
	if (document.body.clientWidth==0) return;
	var oBanner= document.all.item("nsbanner");
	var oText= document.all.item("nstext");
	if (oText == null) return;
/*	var oBannerrow1 = document.all.item("bannerrow1");
	var oTitleRow = document.all.item("titlerow");
	if (oBannerrow1 != null){
		var iScrollWidth = bodyID.scrollWidth;
		oBannerrow1.style.marginRight = 0 - iScrollWidth;
	}
	if (oTitleRow != null){
		oTitleRow.style.padding = "0px 10px 0px 22px; ";
	}*/
	if (oBanner != null){
		document.body.scroll = "no"
		oText.style.overflow= "auto";
 		oBanner.style.width= document.body.offsetWidth - 2;
		oText.style.paddingRight = "20px"; // Width issue code
		oText.style.width= document.body.offsetWidth - 4;
		oText.style.top=0;  
		if (document.body.offsetHeight > oBanner.offsetHeight + 4)
    			oText.style.height= document.body.offsetHeight - (oBanner.offsetHeight + 4) 
		else oText.style.height=0
	}	
	try{
          nstext.setActive();} //allows scrolling from keyboard as soon as page is loaded. Only works in IE 5.5 and above.
	catch(e)
	{
	}
} 

function beginsWith(s1, s2){
	// Does s1 begin with s2?
	return s1.toLowerCase().substring(0, s2.length) == s2.toLowerCase();
}

function getNext(elem){
	for (var i = elem.sourceIndex + 1; i < document.all.length; i++) {
		var next = document.all[i];
		if (!elem.contains(next))
			return next;
	}
	return null;
}



function initSeeAlso(){
	var hdr = document.all.hdr;
	if (!hdr)
		return;

	var divS = new String;
	var heads = document.all.tags("H3");
	if (heads) {
		for (var i = 0; i < heads.length; i++) {
			var head = heads[i];
			var txt = head.innerText;
			if (beginsWith(txt, L_SeeAlso_TEXT) ) {
				divS += head.outerHTML;
				var next = getNext(head);
				while (next && !next.tagName.match(/^(H[1-4])|(DIV)$/)) {
					divS += next.outerHTML;
					next = getNext(next);
				}
			}
		}
	}

	var pos = getNext(hdr.parentElement);
	if (pos) {
		if (divS != "") {
			divS = '<DIV ID=sapop CLASS=sapop onkeypress=ieKey>' + divS + '</DIV>';
			var td = hdr.insertCell(0);
			if (td) {
				td.className = "button1";
				td.onclick = showSeeAlso;
//				td.onkeyup = ieKey;
				td.onkeypress = showSeeAlso;
				td.innerHTML = '<IMG id=button1 SRC="images/seeslso1a.gif' + '" ALT="' + L_SeeAlso_TEXT + '" BORDER=0 TABINDEX=0>';
//				if (advanced)
					nsbanner.insertAdjacentHTML('afterEnd', divS);
//				else
//					document.body.insertAdjacentHTML('beforeEnd', divS);
			}
		}
	}
}

function bodyOnLoad(){

//	if (advanced) {
		
//		try{
			// Wire up event handlers that required the body to have been instantiated.
//			document.body.oncopy = procCodeSelection;
//		} catch(e){}
		
		// Process language-specific subsections and data structures
		// Create the language menu
//		initLangs();
		
		// Filter topic as appropriate for the context
//		if (curLangs != null) {
//			curLangs.filterTopicForLang(null, false);
//		}

		resizeBan();
		
		initReftips();
		initSeeAlso();
		
//	}
	

//	document.onkeypress = ieKey;
//	window.onresize = closeIE4;
	document.body.onclick = bodyOnClick;
	//IF THE USER HAS IE4+ THEY WILL BE ABLE TO VIEW POPUP BOXES
//	if (advanced){
//		document.body.insertAdjacentHTML('beforeEnd', popupDIV);
//	}
	
	//set the scroll position
//	try{nstext.scrollTop = scrollPos;}
//	catch(e){}
	
}
function bodyOnClick(){
//	if (advanced) {
//		var elem = window.event.srcElement;
//		for (; elem; elem = elem.parentElement) {
//			if (elem.id == "reftip")
//				return;
//		}
		hideTip();
//		closeMenu();
		hideSeeAlso();
		resizeBan();
//	}
}


function showSeeAlso(){
	bodyOnClick();
	var btn = window.event.srcElement
	if (btn.id=="button1"){
	btn.src = btn.src.replace("a.gif", "c.gif");}

	window.event.returnValue = false;
	window.event.cancelBubble = true;

	var div = document.all.sapop;
	var lnk = window.event.srcElement;

	if (div && lnk) {
		div.style.pixelTop = lnk.offsetTop + lnk.offsetHeight;
		div.style.visibility = "visible";
	}
}

function hideSeeAlso(){
	var div = document.all.sapop;
	if (div)
		div.style.visibility = "hidden";
	resetButtons();
}

function resetButtons(){
	//unclick buttons...
	var btns = document.all.button1;
	if (btns) {
		if (btns.src!=null) btns.src=btns.src.replace("c.gif", "a.gif"); //if there is only one button.
		for (var i = 0; i < btns.length; i++){
			btns[i].src = btns[i].src.replace("c.gif", "a.gif");
		}
	}
}

// ****************************************************************************
// *                      Reftips (parameter popups)                          *
// ****************************************************************************

function initReftips(){
	var DLs = document.all.tags("DL");
	var PREs = document.all.tags("PRE");
	if (DLs && PREs) {
		var iDL = 0;
		var iPRE = 0;
		var iSyntax = -1;
		for (var iPRE = 0; iPRE < PREs.length; iPRE++) {
			if (PREs[iPRE].className == "syntax") {
				while (iDL < DLs.length && DLs[iDL].sourceIndex < PREs[iPRE].sourceIndex)
					iDL++;			
				if (iDL < DLs.length) {
					initSyntax(PREs[iPRE], DLs[iDL]);
					iSyntax = iPRE;
				}
				else
					break;
			}
		}

		if (iSyntax >= 0) {
			var last = PREs[iSyntax];
			if (last.parentElement.tagName == "DIV") last = last.parentElement;						
			last.insertAdjacentHTML('afterEnd','<DIV ID=reftip CLASS=reftip STYLE="position:absolute;visibility:hidden;overflow:visible;"></DIV>');
		}
	}
}


function initSyntax(pre, dl){
	var strSyn = pre.outerHTML;
	var ichStart = strSyn.indexOf('>', 0) + 1;
//	var terms = dl.children.tags("DT");
        var terms = [];
	for(i = 0; i < dl.children.length; i++) {
	    if(dl.children[i].tagName == "DT") {
	      terms.push(dl.children[i]);
	    }
	}
	if (terms) {
		for (var iTerm = 0; iTerm < terms.length; iTerm++) {
			if (terms[iTerm].innerHTML.indexOf("<!--join-->")!=-1){
				var word = terms[iTerm].innerText.replace(/\s$/, "");
				var ichMatch = findTerm(strSyn, ichStart, word);
				if (ichMatch < 1){
					word = word.replace(/\s/, "&nbsp;")
					ichMatch = findTerm(strSyn, ichStart, word);
				}
				while (ichMatch > 0) {
					var strTag = '<A HREF="" ONCLICK="showTip(this)" CLASS="synParam">' + word + '</A>';

					strSyn =
						strSyn.slice(0, ichMatch) +
						strTag +
						strSyn.slice(ichMatch + word.length);
					ichMatch = findTerm(strSyn, ichMatch + strTag.length, word);
				}
				
			}
		}
		for (var iTerm = 0; iTerm < terms.length; iTerm++) {
			if (terms[iTerm].innerHTML.indexOf("<!--join-->")==-1){
			var words = terms[iTerm].innerText.replace(/\[.+\]/g, " ").replace(/,/g, " ").split(" ");
				var htm = terms[iTerm].innerHTML;
				for (var iWord = 0; iWord < words.length; iWord++) {
					var word = words[iWord];

					if (word.length > 0 && htm.indexOf(word, 0) < 0)
						word = word.replace(/:.+/, "");

					if (word.length > 0) {
						var ichMatch = findTerm(strSyn, ichStart, word);
						while (ichMatch > 0) {
							if (!isLinkText(strSyn.substring(ichMatch))){
								var strTag = '<A HREF="" ONCLICK="showTip(this)" CLASS="synParam">' + word + '</A>';

								strSyn =
									strSyn.slice(0, ichMatch) +
									strTag +
									strSyn.slice(ichMatch + word.length);

								ichMatch = findTerm(strSyn, ichMatch + strTag.length, word);
							}
							else ichMatch = findTerm(strSyn, ichMatch + word.length, word);
						}
					}
				}
			}
		}
	}

	// Replace the syntax block with our modified version.
	pre.outerHTML = strSyn;
}


function findTerm(strSyn, ichPos, strTerm)
{
	var ichMatch = strSyn.indexOf(strTerm, ichPos);
	while (ichMatch >= 0) {
		var prev = (ichMatch == 0) ? '\0' : strSyn.charAt(ichMatch - 1);
		var next = strSyn.charAt(ichMatch + strTerm.length);
		if (!isalnum(prev) && !isalnum(next) && !isInTag(strSyn, ichMatch)) {
			var ichComment = strSyn.indexOf("/*", ichPos);
			while (ichComment >= 0) {
				if (ichComment > ichMatch) { 
					ichComment = -1;
					break; 
				}
				var ichEnd = strSyn.indexOf("*/", ichComment);
				if (ichEnd < 0 || ichEnd > ichMatch)
					break;
				ichComment = strSyn.indexOf("/*", ichEnd);
			}
			if (ichComment < 0) {
				ichComment = strSyn.indexOf("//", ichPos);
				var newPos = 0;
				if (ichComment >= 0) {
					while (isInTag(strSyn, ichComment)) { //checks to see if the comment is in a tag (and thus part of a URL)
						newPos = ichComment + 1;
						ichComment = strSyn.indexOf("//", newPos);
						if (ichComment < 0) 
							break;
					}
					while (ichComment >= 0) {
						if (ichComment > ichMatch) {
							ichComment = -1;
							break; 
						}
						var ichEnd = strSyn.indexOf("\n", ichComment);
						if (ichEnd < 0 || ichEnd > ichMatch)
							break;
						ichComment = strSyn.indexOf("//", ichEnd);
					}
				}
			}
			if (ichComment < 0)
				break;
		}
		ichMatch = strSyn.indexOf(strTerm, ichMatch + strTerm.length);
	}
	return ichMatch;
}
function isLinkText(strHtml){
	return strHtml.indexOf("<")==strHtml.toLowerCase().indexOf("<\/a>");
}

function isInTag(strHtml, ichPos)
{
	return strHtml.lastIndexOf('<', ichPos) >
		strHtml.lastIndexOf('>', ichPos);
}


function isalnum(ch){
	return ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9') || (ch == '_') || (ch == '-'));
}


function showTip(link){
	bodyOnClick();
	var tip = document.all.reftip;
	if (!tip || !link)
		return;

	window.event.returnValue = false;
	window.event.cancelBubble = true;

	// Hide the tip if necessary and initialize its size.
	tip.style.visibility = "hidden";
	tip.style.pixelWidth = 260;
//	tip.style.pixelHeight = 24;

	// Find the link target.
	var term = null;
	var def = null;
	var DLs = document.all.tags("DL");
	for (var iDL = 0; iDL < DLs.length; iDL++) {
		if (DLs[iDL].sourceIndex > link.sourceIndex) {
			var dl = DLs[iDL];
			var iMax = dl.children.length - 1;
			for (var iElem = 0; iElem < iMax; iElem++) {
				var dt = dl.children[iElem];
				if (dt.tagName == "DT" && dt.style.display != "none") {
					if (findTerm(dt.innerText, 0, link.innerText) >= 0) {
						var dd = dl.children[iElem + 1];
						if (dd.tagName == "DD") {
							term = dt;
							def = dd;
						}
						break;
					}
				}
			}
			break;
		}
	}

	if (def) {

		var popupText = null;

		for (var ddIdx = 0, ddEnd = def.children.length; ddIdx < ddEnd; ++ddIdx) {

			var tmp = def.children[ddIdx].tagName.toLowerCase();
			if (tmp == "span") {
				popupText = def.children[ddIdx].innerHTML;
				break;
			}
		}

		if (popupText == null) {
			popupText = def.innerHTML;
		}

		window.linkElement = link;
		window.linkTarget = term;
		tip.innerHTML = '<DL><DT>' + term.innerHTML + '</DT><DD>' + popupText + '</DD></DL>';
		window.setTimeout("moveTip()", 0);
	}
}


function jumpParam(){
	hideTip();

	window.linkTarget.scrollIntoView();
	document.body.scrollLeft = 0;

	flash(3);
}


function flash(c){
	window.linkTarget.style.background = (c & 1) ? "#CCCCCC" : "";
	if (c)
		window.setTimeout("flash(" + (c-1) + ")", 200);
}


function moveTip(){
	var tip = document.all.reftip;
	var link = window.linkElement;
	if (!tip || !link)
		return; //error

	var w = tip.offsetWidth;
	var h = tip.offsetHeight;

//	if (w > tip.style.pixelWidth) {
//		tip.style.pixelWidth = w;
//		window.setTimeout("moveTip()", 0);
//		return;
//	}

	var maxw = document.body.clientWidth-20;
	var maxh = document.body.clientHeight - 200;

	if (h > maxh) {
		if (w < maxw) {
			w = w * 3 / 2;
			tip.style.pixelWidth = (w < maxw) ? w : maxw;
			window.setTimeout("moveTip()", 0);
			return;
		}
	}

	var x,y;

	var linkLeft = link.offsetLeft - document.body.scrollLeft;
	var linkRight = linkLeft + link.offsetWidth;

	try{
		if (navigator.appName == "Microsoft Internet Explorer")
			var linkTop = link.offsetTop - nstext.scrollTop + nstext.offsetTop;
		else
			var linkTop = link.offsetTop;
	}
	catch(e){
		var linkTop = link.offsetTop;
	}
	var linkBottom = linkTop + link.offsetHeight + 4;

	var cxMin = link.offsetWidth - 24;
	if (cxMin < 16)
		cxMin = 16;

	if ((linkLeft + cxMin + w <= maxw)&&(h+linkTop <= maxh + 150)) {
		x = linkLeft;
		y = linkBottom;
	}
	if ((linkLeft + cxMin + w <= maxw)&&(h+linkTop > maxh + 150)) {
		x = maxw - w;
		if (x > linkRight + 8)
			x = linkRight + 8;
		x = linkLeft;
		y = linkTop-h;
	}
	if ((linkLeft + cxMin + w >= maxw)&&(h+linkTop <= maxh + 150)) {
		x = linkRight - w;
		if (x < 0)
			x = 0;
		y=linkBottom;
	}
	if ((linkLeft + cxMin + w >= maxw)&&(h+linkTop > maxh + 150)) {
		x = linkRight - w;
		if (x < 0)
			x = 0;
		y = linkTop-h;
		if (y<0)
			y = 0;
	}
	link.style.background = "#CCCCCC";
	tip.style.pixelLeft = x + document.body.scrollLeft;
	tip.style.pixelTop = y;
	tip.style.visibility = "visible";
}


function hideTip(){
	if (window.linkElement) {
		window.linkElement.style.background = "";
		window.linkElement = null;
	}

	var tip = document.all.reftip;
	if (tip) {
		tip.style.visibility = "hidden";
		tip.innerHTML = "";
	}
}


function beginsWith(s1, s2){
	// Does s1 begin with s2?
	return s1.toLowerCase().substring(0, s2.length) == s2.toLowerCase();
}



if(typeof document.documentElement.sourceIndex == "undefined")
    HTMLElement.prototype.__defineGetter__("sourceIndex", (function(indexOf){
        return function sourceIndex(){
            return indexOf.call(this.ownerDocument.getElementsByTagName("*"), this);
        };
    })(Array.prototype.indexOf));
;

window.onload = bodyOnLoad;
window.onresize = resizeBan;