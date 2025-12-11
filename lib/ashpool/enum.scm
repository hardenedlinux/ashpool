;;  -*-  indent-tabs-mode:nil; coding: utf-8 -*-
;;  Copyright (C) 2025
;;      Roy Mu <roy@hardenedlinux.org>
;;  This file is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Affero General Public License
;;  published by the Free Software Foundation, either version 3 of the
;;  License, or (at your option) any later version.

;;  This file is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Affero General Public License for more details.

;;  You should have received a copy of the GNU Affero General Public License
;;  along with this program.
;;  If not, see <http://www.gnu.org/licenses/>.

(define-module (ashpool enum)
  #:use-module (rnrs)
  #:export (status-enum
            tag-status))

(define *api-status-enum*
  (make-enumeration
   '(ok failed)))
(define status-enum (enum-set-indexier *api-status-enum*))

(define *tag-status*
  (make-enumeration
   '(inactive active forbbidden)))
(define tag-status (enum-set-indexier *tag-status*))
