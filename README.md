# Transformation XSLT : extraits du "MEOT" de Gilbert Simondon

Ce repository contient la transformation d'extraits de l'oeuvre la plus connue de Gilbert Simondon, *Du mode d'existence des objets techniques*, encodé en XML/TEI. La transformation produit un "mini-site".

## Structure des fichiers

- simondon_meot.xml (extraits des chapitres encodés en TEI)

- transform.xsl (feuille de transformation)
  
  - img (quatre images tirées du MEOT : pas de référence interne au texte vers les images : les images sont intercalées entre deux parties)
  
  - out (contient les sorties issues de la transformation, à l'exception de style.css)
    
    - index.html (home/accueil : cliquez sur ce fichier pour accéder au mini-site)
    
    - style.css
    
    - chapitre_0.html (introduction)
    
    - chapitre_1.html
    
    - chapitre_2.html
