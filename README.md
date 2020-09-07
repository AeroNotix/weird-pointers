## weird-pointers

When you need to have what looks like a pointer, but it can be any arbitrary
Lisp object.

This is a contrived example since we define a C function then immediately call
it but you can imagine this is part of a CFFI which is based on
callbacks/user-context.

Now it's super easy to pass a Lisp function to the C function with the context
being a function itself, just use save/restore on the pointer from this library.

```lisp
(defcallback some-c-fun :void ((context :pointer))
 (let ((f (weird-pointers:restore context)))
  (funcall f)))

(let ((context (weird-pointers:save (lambda () (format t "Hi!~%")))))
 (foreign-funcall-pointer (callback some-c-fun) () :pointer context))

=> Hi!
; No value
```

The reason why we don't pass a pointer to the Lisp context directly is that the
garbage collector is free to move things around as it sees fit. It's much
simpler to store a reference to the object and allow the GC to update pointers
to it, rather than to try to do that ourselves.
