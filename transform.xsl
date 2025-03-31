<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:output method="html"/>
    
    <!-- MES VARIABLES-->
    <!-- (METADONNEES)-->
    <xsl:variable name="titre" select="//titleStmt/title"/>
    <xsl:variable name="auteur" select="//titleStmt/author"/>
    <xsl:variable name="editeur" select="//respStmt/name"/>
    
    
    <!-- BLOCS HTML -->
    <!-- ********** -->
    <!-- HEAD HTML -->
    <xsl:variable name="head">
        <head>
         <meta charset="utf-8"/>
         <meta name="viewport" content="width=device-width, initial-scale=1"/>
         <title><xsl:value-of select="$titre"/></title>
          <link rel="stylesheet" href="style.css"/>
         <meta name="description" content="{concat($titre, ' par ', $auteur)}"/>
         <meta name="author" content="{$editeur}"/>
       </head>
    </xsl:variable>
    
    <!-- FOOTER -->
    <xsl:variable name="footer">
        <footer>
            <p>Edition numérique TEI du livre "<xsl:value-of select="$titre"/>" de <xsl:value-of select="$auteur"/>
                réalisé dans le cadre du cours de XSLT du Master TNAH de l'École nationale des chartes.</p>
        </footer>
    </xsl:variable>
    
    <!-- HEADER (attention : distinct de head)-->
    <xsl:variable name="header">
        <header>
            <h1>
                <em><xsl:value-of select="$titre"/></em> de <xsl:value-of select="$auteur"/>
            </h1>
        </header>
    </xsl:variable>
    
    <!-- NAVBAR -->
    <xsl:variable name="navbar">
        <nav>
            <ul>
                <li><a href="index.html">Accueil</a> - </li>
                <xsl:for-each select="//div[@type='chapter']">
                    <li>
                        <a href="{concat('chapitre_', position()-1, '.html')}">
                            <!-- CONDITION pour appeler "Chapitre zéro" en "introduction" -->
                            <xsl:choose>
                                <xsl:when test="@n = 0">Introduction</xsl:when>
                                <xsl:otherwise>Chapitre <xsl:value-of select="@n"/></xsl:otherwise>
                            </xsl:choose>
                        </a> -
                    </li>
                </xsl:for-each>
            </ul>
        </nav>
    </xsl:variable>
    
    <!-- PLANCHES -->
    <xsl:variable name="planches">
        <section class="container">
            <p>Test de rotation d'images via XSLT à travers les attributs "change" de TEI :</p>
            <xsl:for-each select="//div[@type='planches']/figure[@n]">
                <!-- ROTATION AUTOMATIQUE DES IMAGES quand attribut change renseigné-->
                <xsl:variable name="rotation">
                    <xsl:choose>
                        <xsl:when test="./graphic/@change">
                            <xsl:value-of select="./graphic/@change"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <figure>
                    <figcaption><xsl:value-of select="./figDesc"/></figcaption>
                    <img
                        src="../img/{concat('planche_', format-number(@n, '00'), '.png')}"
                        alt="{./head}"
                        style="transform: rotate({$rotation}deg);"/>
                </figure>
            </xsl:for-each>
        </section>
    </xsl:variable>
    
    <!-- TEMPLATES POUR HTML-->
    <!-- INDEX -->
    <xsl:template name="home">
        <xsl:result-document href="out/index.html" method="html" indent="yes">
            <html>
                <xsl:copy-of select="$head"/>
                <body>
                     <xsl:copy-of select="$navbar"/>
                    <main>
                        <xsl:copy-of select="$header"/>
                        <h2>
                            <xsl:value-of select="//titlePart[@type='sub']"/>
                         </h2> 
                        <p>Edité par <xsl:value-of select="//docImprint/publisher"/> à <xsl:value-of select="//docImprint/pubPlace"/></p>
                         
                        <div>
                             <xsl:copy-of select="$planches"/>
                         </div>
                         
                    </main>
                    <xsl:copy-of select="$footer"/>
                </body> 
            </html>
        </xsl:result-document>
    </xsl:template>
  
   
    <!-- CHAPITRES -->
    <xsl:template match="div[@type='chapter']">
        <xsl:variable name="chapitreNum" select="@n"/>
        <xsl:result-document href="{concat('out/chapitre_', $chapitreNum, '.html')}" method="html" indent="yes">
            <html>
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$navbar"/>
                    <main>
                       <xsl:copy-of select="$header"/>
                       <article>
                          
                           <header>
                               <xsl:choose>
                                   <xsl:when test="@n = 0">Introduction</xsl:when>
                                   <xsl:otherwise>Chapitre <xsl:value-of select="@n"/></xsl:otherwise>
                               </xsl:choose>
                           </header>
                           <xsl:apply-templates select="./*"/>
                       </article>
                    </main>
                    <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="div[@type='chapter']/head">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="div[@type='section']/head">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    <xsl:template match="//p">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <!-- APPLICATION des TEMPLATES-->
    <xsl:template match="/">
        <xsl:call-template name="home"/> <!-- J'utilise un simple appel de template car pas de "jeux en cascade" -->
        <xsl:apply-templates select="//text/body"/> <!-- Ici, un apply template, car j'ai besoin de faire "retomber" la logique pour différentes occurences -->
    </xsl:template>
    
</xsl:stylesheet>