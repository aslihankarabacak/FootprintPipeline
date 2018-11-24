;;; Footprint pipeline -- Find transcription factor footprints.
;;; Copyright © 2017 Ricardo Wurmus <rekado@elephly.net>
;;;
;;; This file is part of the footprint pipeline.
;;;
;;; The footprint pipeline is free software; see COPYING file for details.
;;;
;;; Run the following command to enter a development environment:
;;;
;;;  $ guix environment -l guix.scm --ad-hoc autoconf automake
;;;
;;; To install the package from a release tarball do this:
;;;
;;;  $ guix package --with-source=footprint-pipeline-1.0.1.tar.gz -f guix.scm
;;;
;;; This environment file was developed for Guix version
;;; v0.13.0-4697-gef2c6b409

(use-modules (guix packages)
             (guix licenses)
             (guix download)
             (guix build-system ant)
             (guix build-system gnu)
             (gnu packages)
             (gnu packages statistics)
             (gnu packages bioinformatics)
             (gnu packages cran)
             (gnu packages perl))

(define-public samtools-1.1
  (package
    (inherit samtools-0.1)
    (version "1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/samtools/samtools/"
                           version "/samtools-" version ".tar.bz2"))
       (sha256
        (base32
         "1y5p2hs4gif891b4ik20275a8xf3qrr1zh9wpysp4g8m0g1jckf2"))))))

(define %fp-version
  (symbol->string (with-input-from-file "VERSION" read)))

(define-public footprint-pipeline
  (package
    (name "footprint-pipeline")
    (version %fp-version)
    (source (string-append (getcwd) "/footprint-pipeline-" version ".tar.gz"))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'install 'wrap-executable
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out")))
               (wrap-program (string-append out "/bin/find_footprints.sh")
                 `("R_LIBS_SITE" ":" = (,(getenv "R_LIBS_SITE")))))
             #t)))))
    (inputs
     `(("r-minimal" ,r-minimal)
       ("r-mixtools" ,r-mixtools)
       ("r-gtools" ,r-gtools)
       ("r-genomicranges" ,r-genomicranges)
       ("perl" ,perl)
       ("samtools" ,samtools-1.1)
       ("bedtools" ,bedtools-2.18)))
    (home-page "https://ohlerlab.mdc-berlin.de/software/Reproducible_footprinting_139/")
    (synopsis "Find transcription factor footprints in ATAC-seq or DNase-seq data")
    (description "This is a pipeline to find transcription factor
footprints in ATAC-seq or DNase-seq data.")
    (license gpl2+)))

footprint-pipeline
