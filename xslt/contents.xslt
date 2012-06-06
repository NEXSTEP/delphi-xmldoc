<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" indent="yes"  encoding="utf-8" omit-xml-declaration="yes"/>

	<xsl:include href="project.xslt" />

	<xsl:template match="/">

		<html>
			<head>
				<meta name="generator" content="NEXSTEP.XMLDoc" />
				<title>Contents</title>
				<link rel="stylesheet" type="text/css" href="css/tree.css" />
				<script src="js/tree.js" type="text/javascript" />
			</head>
			<body id="docBody" style="background-color: #6699CC; color: White; margin: 0px 0px 0px 0px;" onload="resizeTree()" onresize="resizeTree()" onselectstart="return false;">
				<div style="font-family: verdana; font-size: 8pt; cursor: pointer; margin: 6 4 8 2; text-align: right" onmouseover="this.style.textDecoration='underline'" onmouseout="this.style.textDecoration='none'" onclick="syncTree(window.parent.frames[1].document.URL)">sync toc</div>
				<div id="tree" style="top: 35px; left: 0px;" class="treeDiv">
					<div id="treeRoot" onselectstart="return false" ondragstart="return false">
						<xsl:apply-templates>
							<xsl:sort select="@name" />
						</xsl:apply-templates>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="project">

		<xsl:variable name='project-xml' select="document(concat(document-uri(/), '/../', @name, '.xml'))" />

		<xsl:result-document href="{@name}.html">
		        <xsl:apply-templates select="$project-xml" mode="project">
				<xsl:sort select="@name" />
			</xsl:apply-templates>
		</xsl:result-document>

		<div class='treeNode'>
			<xsl:choose>
				<xsl:when test="$project-xml/namespace/contains">
					<img src="images\treenodeplus.gif" class="treeLinkImage" onclick="expandCollapse(this.parentNode)" />
				</xsl:when>
				<xsl:otherwise>
					<img src="images\treenodedot.gif" class="treeNoLinkImage" />
				</xsl:otherwise>
			</xsl:choose>
			
			<a>
				<xsl:attribute name="href"><xsl:value-of select="concat(@name, '.html')"/></xsl:attribute>
				<xsl:attribute name="target">main</xsl:attribute>
				<xsl:attribute name="class">treeUnselected</xsl:attribute>
				<xsl:attribute name="onclick">clickAnchor(this)</xsl:attribute>
				<xsl:value-of select="@name"/>
			</a>

			<xsl:if test="$project-xml/namespace/contains">
				<div class="treeSubnodesHidden">
					<xsl:apply-templates select="$project-xml" mode="toc-project">
						<xsl:sort select="@name" />
					</xsl:apply-templates>
				</div>
			</xsl:if>
		</div>

	</xsl:template>

	<xsl:template match="contains" mode="toc-project">

		<xsl:variable name='namespace-xml' select="document(concat(document-uri(/), '/../', @name, '.xml'))" />

		<div class='treeNode'>
			<xsl:choose>
				<xsl:when test="$namespace-xml/namespace/*">
					<img src="images\treenodeplus.gif" class="treeLinkImage" onclick="expandCollapse(this.parentNode)" />
				</xsl:when>
				<xsl:otherwise>
					<img src="images\treenodedot.gif" class="treeNoLinkImage" />
				</xsl:otherwise>
			</xsl:choose>
			
			<a>
				<xsl:attribute name="href"><xsl:value-of select="concat(@name, '.html')"/></xsl:attribute>
				<xsl:attribute name="target">main</xsl:attribute>
				<xsl:attribute name="class">treeUnselected</xsl:attribute>
				<xsl:attribute name="onclick">clickAnchor(this)</xsl:attribute>
				<xsl:value-of select="@name"/></a>

			<xsl:if test="$namespace-xml/namespace/*">
				<div class="treeSubnodesHidden">
					<xsl:apply-templates select="$namespace-xml" mode="toc">
						<xsl:sort select="@name" />
					</xsl:apply-templates>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- Unit members -->
	<xsl:template match="namespace" mode="toc">
			<xsl:call-template name="toc-type-list">
				<xsl:with-param name="type">Interfaces</xsl:with-param>
				<xsl:with-param name="nodes" select="interface" />
			</xsl:call-template>
			<xsl:call-template name="toc-type-list">
				<xsl:with-param name="type">Classes</xsl:with-param>
				<xsl:with-param name="nodes" select="class" />
			</xsl:call-template>
			<xsl:call-template name="toc-type-list">
				<xsl:with-param name="type">Records</xsl:with-param>
				<xsl:with-param name="nodes" select="struct" />
			</xsl:call-template>
			<xsl:call-template name="toc-type-list">
				<xsl:with-param name="type">Types</xsl:with-param>
				<xsl:with-param name="nodes" select="type | pointer | array | enum | set | classref" />
			</xsl:call-template>
			<xsl:call-template name="toc-type-list">
				<xsl:with-param name="type">Procedures &amp; Functions</xsl:with-param>
				<xsl:with-param name="nodes" select="procedure | function" />
			</xsl:call-template>
			<xsl:call-template name="toc-type-list">
				<xsl:with-param name="type">Variables &amp; Constants</xsl:with-param>
				<xsl:with-param name="nodes" select="variable | const" />
			</xsl:call-template>
	</xsl:template>

	<!-- Unit member groups -->
	<xsl:template name="toc-type-list">
		<xsl:param name="type" />
		<xsl:param name="nodes">
		<!--xsl:copy-of select="./node()[name()=$type]"/-->
		</xsl:param>

		<xsl:if test="$nodes">
			<!-- unit members group name (e.g. 'Procedures & Functions') -->
			<div class='treeNode'>
				<img src="images\treenodeplus.gif" class="treeLinkImage" onclick="expandCollapse(this.parentNode)" />
				<a>
					<xsl:attribute name="href">
						<xsl:call-template name="calc-link-url">
							<xsl:with-param name="namespace" select="@name" />
							<xsl:with-param name="suffix" select="$type" />
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="target">main</xsl:attribute>
					<xsl:attribute name="class">treeUnselected</xsl:attribute>
					<xsl:attribute name="onclick">clickAnchor(this)</xsl:attribute>
					<xsl:value-of select="$type"/></a>

				<!-- group members -->
				<div class="treeSubnodesHidden">
					<xsl:apply-templates select="$nodes" mode="toc">
						<xsl:sort select="@name" />
					</xsl:apply-templates>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- group member (e.g. TMyCoolObject class or CoolProc function) -->
	<xsl:template match="class | struct | interface | procedure | function | const | variable | type | pointer | array | enum | set | classref" mode="toc">
		<xsl:variable name="namespace" select="../@name" />
		<xsl:variable name="metatype" select="local-name()" />
		<xsl:variable name="type" select="@name" />
	
		<xsl:if test="count(preceding-sibling::node()[@name=$type]) = 0">
			<!-- group member name (e.g. 'TMyCoolObject class') -->
			<div class='treeNode'>

				<xsl:choose>
					<xsl:when test="local-name()='class'or local-name()='interface' or local-name()='struct'">
						<img src="images\treenodeplus.gif" class="treeLinkImage" onclick="expandCollapse(this.parentNode)" />
					</xsl:when>
					<xsl:otherwise>
						<img src="images\treenodedot.gif" class="treeNoLinkImage" />
					</xsl:otherwise>
				</xsl:choose>

				<a>
					<xsl:attribute name="href">
						<xsl:call-template name="get-filename-for-type">
							<xsl:with-param name="namespace" select="$namespace" />
							<xsl:with-param name="name" select="$type" />
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="target">main</xsl:attribute>
					<xsl:attribute name="class">treeUnselected</xsl:attribute>
					<xsl:attribute name="onclick">clickAnchor(this)</xsl:attribute>
					<xsl:value-of select="$type" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="$typeConfigurations/node()[name()=$metatype]/singular" />
				</a>

				<xsl:if test="local-name()='class'or local-name()='interface' or local-name()='struct'">
					<div class="treeSubnodesHidden">

						<!-- link to class/record/interface members -->
						<div class='treeNode'>
							<img src="images\treenodedot.gif" class="treeNoLinkImage" />

							<a>
								<xsl:attribute name="href">
										<xsl:call-template name="get-filename-for-type-members">
											<xsl:with-param name="namespace" select="$namespace" />
											<xsl:with-param name="name" select="$type" />
										</xsl:call-template>
								</xsl:attribute>
								<xsl:attribute name="target">main</xsl:attribute>
								<xsl:attribute name="class">treeUnselected</xsl:attribute>
								<xsl:attribute name="onclick">clickAnchor(this)</xsl:attribute>
								<xsl:value-of select="$type" /><xsl:text> Members</xsl:text>
							</a>
						</div>

						<!-- class/record/interface member groups (e.g. Methods, Properties, etc) -->
						<xsl:choose>
							<xsl:when test="local-name()='class'">
								<xsl:call-template name="toc-members-list">
									<xsl:with-param name="namespace" select="$namespace" />
									<xsl:with-param name="name" select="$type" />
									<xsl:with-param name="type">Constructors &amp; Destructors</xsl:with-param>
									<xsl:with-param name="nodes" select="members/constructor[@visibility='published' or @visibility='public' or @visibility='protected'] | members/destructor[@visibility='published' or @visibility='public' or @visibility='protected']" />
								</xsl:call-template>
								<xsl:call-template name="toc-members-list">
									<xsl:with-param name="namespace" select="$namespace" />
									<xsl:with-param name="name" select="$type" />
									<xsl:with-param name="type">Types</xsl:with-param>
									<xsl:with-param name="nodes" select="members/type[@visibility='published' or @visibility='public' or @visibility='protected'] | members/array[@visibility='published' or @visibility='public' or @visibility='protected'] | members/enum[@visibility='published' or @visibility='public' or @visibility='protected'] | members/pointer[@visibility='published' or @visibility='public' or @visibility='protected'] | members/classref[@visibility='published' or @visibility='public' or @visibility='protected'] | members/set[@visibility='published' or @visibility='public' or @visibility='protected']" />
								</xsl:call-template>
								<xsl:call-template name="toc-members-list">
									<xsl:with-param name="namespace" select="$namespace" />
									<xsl:with-param name="name" select="$type" />
									<xsl:with-param name="type">Fields</xsl:with-param>
									<xsl:with-param name="nodes" select="members/field[@visibility='published' or @visibility='public' or @visibility='protected']" />
								</xsl:call-template>
								<xsl:call-template name="toc-members-list">
									<xsl:with-param name="namespace" select="$namespace" />
									<xsl:with-param name="name" select="$type" />
									<xsl:with-param name="type">Methods</xsl:with-param>
									<xsl:with-param name="nodes" select="members/procedure[@visibility='published' or @visibility='public' or @visibility='protected'] | members/function[@visibility='published' or @visibility='public' or @visibility='protected']" />
								</xsl:call-template>
								<xsl:call-template name="toc-members-list">
									<xsl:with-param name="namespace" select="$namespace" />
									<xsl:with-param name="name" select="$type" />
									<xsl:with-param name="type">Properties</xsl:with-param>
									<xsl:with-param name="nodes" select="members/property[@visibility='published' or @visibility='public' or @visibility='protected']" />
								</xsl:call-template>
								<xsl:call-template name="toc-members-list">
									<xsl:with-param name="namespace" select="$namespace" />
									<xsl:with-param name="name" select="$type" />
									<xsl:with-param name="type">Events</xsl:with-param>
									<xsl:with-param name="nodes" select="members/event[@visibility='published' or @visibility='public' or @visibility='protected']" />
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="toc-members-list">
									<xsl:with-param name="namespace" select="$namespace" />
									<xsl:with-param name="name" select="$type" />
									<xsl:with-param name="type">Fields</xsl:with-param>
									<xsl:with-param name="nodes" select="field[@visibility='published' or @visibility='public' or @visibility='protected']" />
								</xsl:call-template>
								<xsl:call-template name="toc-members-list">
									<xsl:with-param name="namespace" select="$namespace" />
									<xsl:with-param name="name" select="$type" />
									<xsl:with-param name="type">Methods</xsl:with-param>
									<xsl:with-param name="nodes" select="procedure[@visibility='published' or @visibility='public' or @visibility='protected'] | function[@visibility='published' or @visibility='public' or @visibility='protected']" />
								</xsl:call-template>
								<xsl:call-template name="toc-members-list">
								<xsl:with-param name="namespace" select="$namespace" />
									<xsl:with-param name="name" select="$type" />
									<xsl:with-param name="type">Properties</xsl:with-param>
									<xsl:with-param name="nodes" select="property[@visibility='published' or @visibility='public' or @visibility='protected']" />
								</xsl:call-template>
								<xsl:call-template name="toc-members-list">
									<xsl:with-param name="namespace" select="$namespace" />
									<xsl:with-param name="name" select="$type" />
									<xsl:with-param name="type">Events</xsl:with-param>
									<xsl:with-param name="nodes" select="event[@visibility='published' or @visibility='public' or @visibility='protected']" />
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>


	<!-- class/record/interface members -->
	<xsl:template name="toc-members-list">
		<xsl:param name="namespace" />
		<xsl:param name="name" />
		<xsl:param name="type" />
		<xsl:param name="nodes" />

		<xsl:if test="$nodes">
			<div class='treeNode'>
				<img src="images\treenodeplus.gif" class="treeLinkImage" onclick="expandCollapse(this.parentNode)" />

				<a>
					<xsl:attribute name="href">
						<xsl:call-template name="calc-link-url">
							<xsl:with-param name="namespace" select="$namespace" />
							<xsl:with-param name="name" select="$name" />
							<xsl:with-param name="suffix" select="$type" />
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="target">main</xsl:attribute>
					<xsl:attribute name="class">treeUnselected</xsl:attribute>
					<xsl:attribute name="onclick">clickAnchor(this)</xsl:attribute>
					<xsl:value-of select="$type" />
				</a>

				<div class="treeSubnodesHidden">
					<xsl:apply-templates select="$nodes" mode="toc-members" >
						<xsl:sort select="@name" />
					</xsl:apply-templates>
				</div>

			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="constructor | destructor | procedure | function | const | field | event | array | type | enum | set | pointer | property" mode="toc-members">
		<xsl:variable name="metatype" select="local-name()" />
		<xsl:variable name="type" select="@name" />

		<xsl:if test="count(preceding-sibling::node()[@name=$type]) = 0">
			<div class='treeNode'>
				<img src="images\treenodedot.gif" class="treeNoLinkImage" />

				<a>
					<xsl:attribute name="href">
						<xsl:call-template name="get-member-filename">
							<xsl:with-param name="with-id">0</xsl:with-param>
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="target">main</xsl:attribute>
					<xsl:attribute name="class">treeUnselected</xsl:attribute>
					<xsl:attribute name="onclick">clickAnchor(this)</xsl:attribute>
					<xsl:value-of select="@name" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="$typeConfigurations/node()[name()=$metatype]/singular" />
				</a>
			</div>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>