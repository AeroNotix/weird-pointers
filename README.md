## weird-pointers

When you need to have what looks like a pointer, but it can be any arbitrary
Lisp object.

This is a contrived example since we define a C function then immediately call
it but you can imagine this is part of a CFFI which is based on
callbacks/user-context.

Now it's super easy to pass a Lisp function to the C function with the context
being a function itself, just use save/restore on the pointer from this library.

```lisp
(defcfun some-c-fun :void ((context :pointer))
 (let ((f (weird-pointers:restore context)))
  (funcall f)))

(let ((context (weird-pointers:save (lambda () (format t "Hi!~%)))))
  (some-c-fun context))
```
