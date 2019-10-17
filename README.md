# Word count based on approximate stems
An R script that finds the count of the important words in a text using their approximate stems.


Parts that were used that belong to other repositories:
1. The Fi.csv file was taken from this repository: https://github.com/datquocnguyen/RDRPOSTagger/blob/master/Models/POS/English.DICT and as per the request of it's creator here are the citations that should be included:

    - Dat Quoc Nguyen, Dai Quoc Nguyen, Dang Duc Pham and Son Bao Pham. [RDRPOSTagger: A Ripple Down Rules-based Part-Of-Speech Tagger](http://www.aclweb.org/anthology/E14-2005). In *Proceedings of the Demonstrations at the 14th Conference of the European Chapter of the Association for Computational Linguistics*, EACL 2014, pp. 17-20, 2014. <a href="http://www.aclweb.org/anthology/E14-2005">[.PDF]</a> <a href="http://www.aclweb.org/anthology/E14-2005.bib">[.bib]</a>
    
    - Dat Quoc Nguyen, Dai Quoc Nguyen, Dang Duc Pham and Son Bao Pham. [A Robust Transformation-Based Learning Approach Using Ripple Down Rules for Part-Of-Speech Tagging](http://content.iospress.com/articles/ai-communications/aic698). *AI Communications* (AICom), vol. 29, no. 3, pp. 409-422, 2016. <a href="http://arxiv.org/pdf/1412.4021.pdf">[.PDF]</a> <a href="http://rdrpostagger.sourceforge.net/AICom.bib">[.bib]</a>
    
2. The FiN.csv file was constructed by using the [inflect python library](https://github.com/jazzband/inflect) on the Fi.csv data. 
