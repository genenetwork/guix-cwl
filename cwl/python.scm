(define-module (cwl python)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages attr)
  #:use-module (gnu packages base)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages rdf)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages statistics)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages time)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (guix build-system trivial)
  #:use-module (srfi srfi-1))

(define-public python-setuptools-vtags ; use this specific version for CWL to deal with self.vtags
  (package
    (name "python-setuptools-vtags")
    (version "40.6.2")
    (source
     (origin
      (method url-fetch)
      (uri "https://files.pythonhosted.org/packages/37/1b/b25507861991beeade31473868463dad0e58b1978c209de27384ae541b0b/setuptools-40.6.3.zip"
             )
      (sha256
       (base32
        "1y085dnk574sxw9aymdng9gijvrsbw86hsv9hqnhv7y4d6nlsirv"))
      (modules '((guix build utils)))
      (snippet
       '(begin
          ;; Remove included binaries which are used to build self-extracting
          ;; installers for Windows.
          ;; TODO: Find some way to build them ourself so we can include them.
          (for-each delete-file (find-files "setuptools" "^(cli|gui).*\\.exe$"))
          #t))))
    (build-system python-build-system)
    ;; FIXME: Tests require pytest, which itself relies on setuptools.
    ;; One could bootstrap with an internal untested setuptools.
    (arguments
     `(#:tests? #f))
    (home-page "https://pypi.python.org/pypi/setuptools")
    (synopsis
     "Library designed to facilitate packaging Python projects")
    (description
     "Setuptools is a fully-featured, stable library designed to facilitate
packaging Python projects, where packaging includes:
Python package and module definitions,
distribution package metadata,
test hooks,
project installation,
platform-specific details,
Python 3 support.")
    ;; TODO: setuptools now bundles the following libraries:
    ;; packaging, pyparsing, six and appdirs. How to unbundle?
    (license (list license:psfl        ; setuptools itself
                   license:expat       ; six, appdirs, pyparsing
                   license:asl2.0      ; packaging is dual ASL2/BSD-2
                   license:bsd-2))))


(define-public python-typing-extensions; guix candidate
  (package
   (name "python-typing-extensions")
   (version "3.6.6")
   (source
    (origin
     (method url-fetch)
     (uri "https://files.pythonhosted.org/packages/fc/e6/3d2f306b12f01bde2861d67458d32c673e206d6fcc255537bf452db8f80c/typing_extensions-3.6.6.tar.gz")
     (sha256
      (base32
       "07vhddjnd3mhdijyc3s0mwi9jgfjp3rr056nxqiavydbvkrvgrsi"))))
   (build-system python-build-system)
   (home-page "https://pypi.python.org/pypi/typing_extensions")
   (synopsis
    "Python typing_extensions.")
   (description
    "Python typing_extensions.")
   (license license:gpl2))
  )

(define-public python-subprocess32 ; guix candidate
  (package
   (name "python-subprocess32")
   (version "0.2.9")
   (source
    (origin
     (method url-fetch)
     (uri "https://files.pythonhosted.org/packages/be/2b/beeba583e9877e64db10b52a96915afc0feabf7144dcbf2a0d0ea68bf73d/subprocess32-3.5.3.tar.gz")
     (sha256
      (base32
       "1hr5fan8i719hmlmz73hf8rhq74014w07d8ryg7krvvf6692kj3b"))))
   (build-system python-build-system)
   (arguments `(#:tests? #f)) ;; No tests.
   (home-page "https://pypi.python.org/pypi/subprocess32")
   (synopsis
    "Python subprocess32.")
   (description
    "Python subprocess32.")
   (license license:gpl2))
  )

(define-public python-rdflib-jsonld ; guix ready
  (package
    (name "python-rdflib-jsonld")
    (version "0.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rdflib-jsonld" version))
        (sha256
          (base32
            "0bdw2pbjmpy1l4p6slsjn54bqy6crk5hk4san84xxirgd9w78iql"))))
    (build-system python-build-system)
    (inputs
      `(("python-setuptools" ,python-setuptools)))
    (propagated-inputs
     `(("python-rdflib" ,python-rdflib)
       ("python-isodate" ,python-isodate)
       ("python-pyparsing" ,python-pyparsing)
       ("python-html5lib" ,python-html5lib)
       ("python-nose" ,python-nose)
))
    (home-page
      "https://github.com/RDFLib/rdflib-jsonld")
    (synopsis
      "rdflib extension adding JSON-LD parser and serializer")
    (description
      "rdflib extension adding JSON-LD parser and serializer")
    (license license:bsd-3)))

(define-public python2-rdflib-jsonld
  (package-with-python2 python-rdflib-jsonld))

(define-public python-prov ; guix candidate
(package
  (name "python-prov")
  (version "1.5.3")
  (source
    (origin
      (method url-fetch)
      (uri (pypi-uri "prov" version))
      (sha256
        (base32
          "1a9h406laclxalmdny37m0yyw7y17n359akclbahimdggq853jd0"))))
  (build-system python-build-system)
  (inputs
       `(("python-rdflib" ,python-rdflib)
       ("python-lxml" ,python-lxml)
       ("python-networkx" ,python-networkx)
       ("python-dateutil" ,python-dateutil)
       ("python-pydot" ,python-pydot)
       ("graphviz" ,graphviz) ; for testing
       ))
  (home-page "https://github.com/trungdong/prov")
  (synopsis
    "A library for W3C Provenance Data Model supporting PROV-JSON, PROV-XML and PROV-O (RDF)")
  (description
    "A library for W3C Provenance Data Model supporting PROV-JSON, PROV-XML and PROV-O (RDF)")
  (license license:expat)))

(define-public python-avro ; guix ready - used by CWL
(package
  (name "python-avro")
  (version "1.8.2")
  (source
    (origin
      (method url-fetch)
        (uri (pypi-uri "avro" version))
      (sha256
        (base32
          "0nabn1hzj1880qsp7fkg7923c0xdqk4i35s15asmy2xp604f97lg"))))
  (build-system python-build-system)
  (inputs
    `(("python-setuptools" ,python-setuptools)))
  (home-page "http://hadoop.apache.org/avro")
  (synopsis
    "Avro is a serialization and RPC framework.")
  (description
    "Avro is a serialization and RPC framework.")
  (license #f)))

(define-public python2-avro
  (package-with-python2 python-avro))

(define-public python-shellescape ; guix ready
(package
  (name "python-shellescape")
  (version "3.4.1")
  (source
    (origin
      (method url-fetch)
      (uri (string-append
             "https://pypi.python.org/packages/source/s/shellescape/shellescape-"
             version
             ".tar.gz"))
      (sha256
        (base32
          "0n5ky1b2vw2y0d4xl3qybyp2rk0gq5frjs8nr8ak6mgj2fyb4676"))))
  (build-system python-build-system)
  (inputs
    `(("python-setuptools" ,python-setuptools)))
  (home-page
    "https://github.com/chrissimpkins/shellescape")
  (synopsis
    "Shell escape a string to safely use it as a token in a shell command (backport of Python shlex.quote for Python versions 2.x & < 3.3)")
  (description
    "Shell escape a string to safely use it as a token in a shell command (backport of Python shlex.quote for Python versions 2.x & < 3.3)")
  (license expat))
)

(define-public python2-shellescape
  (package-with-python2 python-shellescape))

(define-public python2-htmlgen-gn ; guix obsolete
(package
  (name "python2-htmlgen-gn")
  (version "2.2.2")
  (source (origin
           (method url-fetch)
           ;; http://files.genenetwork.org/software/contrib/htmlgen-2.2.2-gn.tar.gz
           (uri (string-append
                 "http://files.genenetwork.org/software/contrib/htmlgen-"
version "-gn.tar.gz"))
           (sha256
            (base32
             "1lwsk56rymhrma46cbyh3g64ksmq1vsih3qkrc2vh0lpba825y7r"))
           ;;(patches (list
           ;;          (search-patch "python2-htmlgen-Applied-Deb-patch.patch")
           ;;          (search-patch "python2-htmlgen-Fix-test-for-random.patch")
            ))
  (build-system python-build-system)
  (outputs '("out"))
  (native-inputs
   `(("make" ,gnu-make)
     ))
  (propagated-inputs
   `(("python2" ,python-2)))
  (arguments
   `(#:phases (modify-phases %standard-phases
     (replace 'build
              (lambda _
                (system* "python2" "-m" "compileall" ".")))
     (replace 'install
              (lambda* (#:key outputs #:allow-other-keys)
                       (let* ((out (assoc-ref outputs "out"))
                              (include (string-append out "/include"))
                              (lib2 (string-append out "/lib/htmlgen"))
                              (lib (string-append (assoc-ref %outputs "out") "/lib/python2.7/site-packages/htmlgen"))
                              (pkgconfig (string-append out "/lib/pkgconfig"))
                              (doc (string-append out "/share/doc")))
                         ;; Install libs and headers.
                         ;; (copy-file "HTMLgen.pyc" "HTMLgen2.pyc")
                         (install-file "HTMLgen.pyc" lib)
                         (install-file "HTMLgen2.pyc" lib)
                         (install-file "imgsize.pyc" lib)
                         (install-file "ImageH.pyc" lib)
                         (install-file "ImagePaletteH.pyc" lib)
                         (install-file "__init__.pyc" lib)
              ))) ; install
     ) ; phases
     #:tests? #f))
  (home-page
    "https://packages.debian.org/unstable/python/python-htmlgen")
  (synopsis "Genenetwork version of Python2 HTMLgen (defunkt
project)")
  (description #f)
  (license #f)))

(define-public python2-pil1 ; guix obsolete
  (package
    (name "python2-pil1")
    (version "1.1.6")
    (source (origin
             (method url-fetch)
             (uri (string-append
                   "http://files.genenetwork.org/software/contrib/Imaging-"
                   version "-gn.tar.gz"))
             (sha256
              (base32
               "0jhinbcq2k899c76m1jc5a3z39k6ajghiavpzi6991hbg6xhxdzg"))
    (modules '((guix build utils)))
    (snippet
     ;; Adapt to newer freetype. As the package is unmaintained upstream,
     ;; there is no use in creating a patch and reporting it.
     '(substitute* "_imagingft.c"
                   (("freetype/")
                    "freetype2/freetype/")))))
    (build-system python-build-system)
    (inputs
      `(("freetype" ,freetype)
        ("libjpeg" ,libjpeg)
        ("libtiff" ,libtiff)
        ("python2-setuptools" ,python2-setuptools)
        ("zlib" ,zlib)))
    (arguments
     ;; Only the fork python-pillow works with Python 3.
     `(#:python ,python-2
       #:tests? #f ; no check target
       #:phases
         (alist-cons-before
          'build 'configure
          ;; According to README and setup.py, manual configuration is
          ;; the preferred way of "searching" for inputs.
          ;; lcms is not found, TCL_ROOT refers to the unavailable tkinter.
          (lambda* (#:key inputs #:allow-other-keys)
            (let ((jpeg (assoc-ref inputs "libjpeg"))
                  (zlib (assoc-ref inputs "zlib"))
                  (tiff (assoc-ref inputs "libtiff"))
                  (freetype (assoc-ref inputs "freetype")))
              (substitute* "setup.py"
                (("JPEG_ROOT = None")
                 (string-append "JPEG_ROOT = libinclude(\"" jpeg "\")"))
                (("ZLIB_ROOT = None")
                 (string-append "ZLIB_ROOT = libinclude(\"" zlib "\")"))
                (("TIFF_ROOT = None")
                 (string-append "TIFF_ROOT = libinclude(\"" tiff "\")"))
                (("FREETYPE_ROOT = None")
                 (string-append "FREETYPE_ROOT = libinclude(\""
                                freetype "\")")))))
          %standard-phases)))
    (home-page "http://www.pythonware.com/products/pil/")
    (synopsis "Python Imaging Library")
    (description "The Python Imaging Library (PIL) adds image processing
capabilities to the Python interpreter.")
    (license (license:x11-style
               "file://README"
               "See 'README' in the distribution."))))

(define-public python2-piddle-gn ; guix obsolete
  (package
    (name "python2-piddle")
    (version "1.0.15-gn-PIL1")
    (source (origin
     (method url-fetch)
     (uri (string-append
           "http://files.genenetwork.org/software/contrib/piddle-"
version ".tgz"))
     (sha256
      (base32
       "1m89xp0d7d5a0nd483qir7zq99ci6wab1r018i698wjdpr8zf86b"))))

    (build-system python-build-system)
    (native-inputs
     `(("python2-setuptools" ,python2-setuptools)))
    (propagated-inputs
     `(("python2-pil1" ,python2-pil1)))
    (arguments
     `(
       #:python ,python-2
       #:tests? #f   ; no 'setup.py test' really!
    ))
    (home-page #f)
    (synopsis "Canvas drawing library for python2 (old!)")
    (description #f)
    (license #f)))

(define-public python2-parallel ; guix fix number of things
  (package
    (name "python2-parallel")
    (version "1.6.4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://www.parallelpython.com/downloads/pp/pp-" version ".zip"
             ))
       (sha256
        (base32
         "1bw3j0zn7bj56636vp1vx4m91p2mlp661gn2nfhpbph3prgxzv82"))))
    (native-inputs
     `(("unzip" ,unzip)))

    (build-system python-build-system)
    ;; (native-inputs
    ;; `(("python-setuptools" ,python-setuptools)))
    (arguments
     `(#:python ,python-2
       #:tests? #f
       ))   ; no 'setup.py test' really!
    (home-page #f)
    (synopsis "Parallel python lib")
    (description #f)
    (license #f)))

(define-public python2-numarray ; guix: obsolete lib
  (package
    (name "python2-numarray")
    (version "1.5.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "mirror://sourceforge/numpy/numarray-" version ".tar.gz"
             ))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "0x1i4j7yni7k4p9kjxs1lgln1psdmyrz65wp2yr35yn292iw2vbg"))))
    (build-system python-build-system)
    (native-inputs
     `(("python2-setuptools" ,python2-setuptools)))
    (arguments
     `(#:python ,python-2
       #:phases
       (modify-phases %standard-phases
         (replace 'build
           (lambda* (#:key inputs #:allow-other-keys)
             (zero? (system* "python" "setup.py" "build"))))
         (replace 'install
                  (lambda* (#:key outputs #:allow-other-keys)
                    ;; Build and install the Python bindings.  The underlying
                    ;; C++ library is apparently not meant to be installed.
                    (let ((out (assoc-ref outputs "out")))
                      (system* "python" "setup.py" "install"
                               (string-append "--prefix=" out))))))
       #:tests? #f))   ; no 'setup.py test' really!
    (home-page "http://www.numpy.org/")
    (synopsis "Numerical library array processing of numbers, strings, records and objects")
    (description
     "Numarray is an (OBSOLETE) array processing package designed to
efficiently manipulate large multi-dimensional arrays. Numarray is
modelled after Numeric and features c-code generated from python
template scripts, the capacity to operate directly on arrays in files,
and improved type promotions. Numarray provides support for
manipulating arrays consisting of numbers, strings, records, or
objects using the same basic infrastructure and syntax.  Numarray is
now part of the numpy package, though some legacy software still uses
the older versions.")
    (license license:gpl2))) ; actualy PyRAF http://www.stsci.edu/resources/software_hardware/pyraf/LICENSE

(define-public python-htmlgen
  (package
    (name "python-htmlgen")
    (version "1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
	     "https://github.com/srittau/python-htmlgen/archive/v"
	     version ".tar.gz"))
       (sha256
	(base32
	 "1rwgqxhmc93l60wf4ay7ph619710kvyp73s22i0snjpm5i0bhc46"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f))
    (synopsis "Python HTML 5 Generator")
    (description "This is a python library for generating html from classes.")
    (home-page "https://github.com/srittau/python-htmlgen")
    (license license:expat)))

(define-public python-version
(let ((commit "e5aadc720bb74c535f29e5a2de5cd9697efe8d7c"))
(package
  (name "python-version")
  (version "0.1.2")
  (source
    (origin
      (method git-fetch)
      (uri (git-reference
      ; (url "https://github.com/genenetwork/pylmm.git")
        (url "https://github.com/keleshev/version.git") ; version not in pypi
        (commit commit)))
      (file-name (string-append name "-" commit))
      (sha256
        (base32
          "1rc8kf72v180qlygkh1y0jwv2fxqpx7n97bqfhbwgnn31iwai9g3"))))
  (build-system python-build-system)
  (build-system python-build-system)
  (propagated-inputs
    `(
    ("python-more-itertools" ,python-more-itertools)
    ("python-pytest" ,python-pytest)))
  (home-page "http://github.com/halst/version")
  (synopsis "Implementation of semantic version")
  (description
    "Implementation of semantic version")
  (license license:expat)
)))

(define-public python-mypy-extensions
(package
  (name "python-mypy-extensions")
  (version "0.4.1")
  (source
    (origin
      (method url-fetch)
      (uri (pypi-uri "mypy_extensions" version))
      (sha256
        (base32
          "04h8brrbbx151dfa2cvvlnxgmb5wa00mhd2z7nd20s8kyibfkq1p"))))
  (build-system python-build-system)
  (propagated-inputs
    `(("python-version" ,python-version)
      ("python-typing" ,python-typing)))
  (home-page "http://www.mypy-lang.org/")
  (synopsis
    "Experimental type system extensions for programs checked with the mypy typechecker.")
  (description
    "Experimental type system extensions for programs checked with the mypy typechecker.")
  (license #f))
)


(define-public python-arcp
(package
  (name "python-arcp")
  (version "0.2.0")
  (source
    (origin
      (method url-fetch)
      (uri (pypi-uri "arcp" version))
      (sha256
        (base32
          "0h8sn0mlb6vb8wqqnqc4pxdklrkyx3p72afdhm7b9kyalrqzd7dd"))))
  (build-system python-build-system)
  (home-page "http://arcp.readthedocs.io/")
  (synopsis
    "arcp (Archive and Package) URI parser and generator")
  (description
    "arcp (Archive and Package) URI parser and generator")
  (license license:asl2.0))
)

(define-public python-bagit; guix candidate
  (package
   (name "python-bagit")
   (version "1.7.0")
   (source
    (origin
     (method url-fetch)
     (uri "https://files.pythonhosted.org/packages/ee/11/7a7fa81c0d43fb4d449d418eba57fc6c77959754c5c2259a215152810555/bagit-1.7.0.tar.gz")
     (sha256
      (base32
       "1m6y04qmig0b5hzb35lnaw3d2yfydb7alyr1579yblvgs3da6j7j"))))
   (build-system python-build-system)
   (inputs
    `(("python-setuptools-scm" ,python-setuptools-scm)
      ("python-coverage" ,python-coverage)
      ("python-mock" ,python-mock)
      ))
   (arguments `(#:tests? #f)) ;; No tests.
   (home-page "https://pypi.python.org/pypi/bagit")
   (synopsis
    "Python bagit.")
   (description
    "Python bagit.")
   (license license:gpl2)))
