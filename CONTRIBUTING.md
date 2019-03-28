# Contributing Guide

## Filing a Bug Report

**You can submit bug reports on the [GitHub issue tracker][issues]**.

If you believe you have found a bug, please include a few things in your report:

1. **A minimal reproduction of the issue**. Providing a huge blob of code is
   better than nothing, but providing the shortest possible set of instructions
   is even better. Take out any instructions or code that, when removed, have
   no effect on the problematic behavior. The easier your bug is to triage and
   diagnose, the higher up in the priority list it will go. We can do this stuff,
   but limited time means this may not happen immediately. Make your bug report
   extremely accessible and you will almost guarantee a quick fix.

2. **Your environment and relevant versions**. Please include your Ruby
   and system versions (including OS) when reporting a bug. This
   makes it easier to diagnose problems. If the issue or stack trace
   includes another library, consider also listing any dependencies
   that may be affecting the issue. This is where a minimal reproduction
   case helps a lot.

3. **Your expected result**. Tell us what you think should happen. This
   helps us to understand the context of your problem. Many complex features
   can contain ambiguous usage, and your use case may differ from the
   intended one. If we know your expectations, we can more easily determine
   if the behavior is intentional or not.

Finally, please **DO NOT** submit a report that states a feature simply
*"does not work"* without any additional information in the report. Consider
the issue from the maintainer's perspective: in order to fix your bug, we
need to drill down to the broken line of code, and in order to do this,
we must be able to reproduce the issue on our end to find that line of
code. The easier we can do this, the quicker your bug gets fixed. Help
us help you by providing as much information as you possibly can. We may
not have the tools or environment to properly diagnose your issue, so
your help may be required to debug the issue.

Also **consider opening a pull request** to fix the issue yourself if you can.
This will likely speed up the fix time significantly. See below for
information on how to do this.

## Asking a Question

**Questions are accepted on [GitHub issues][issues]**.

## Asking for a Feature

**We does not currently accept feature requests filed as GitHub issues**. If
you are looking to have a feature implemented into this gem, consider doing this
yourself and [submitting a pull request][pr] (PR) with your work. If the work
required is involved, consider opening an issue to ask a question; we will be happy to have a conversation and let you know if the feature would be considered. They usually are, but it might be prudent to ask first!

Please do not fret if your feature request gets closed immediately. We do this
to keep our issue tracker clean. **Closing an issue does not mean it would not**
**be accepted as a pull request**. If the feature would not be accepted as a
PR, this will be communicated in the closed issue.

## Making a Change via Pull Request

**You can also submit pull requests on our [GitHub issue tracker][issues]**.

If you've been working on a patch or feature that you want in this gem, here are
some tips to ensure the quickest turnaround time on getting it merged in:

1. **Keep your changes small**. If your feature is large, consider splitting
   it up into smaller portions and submit pull requests for each component
   individually. Feel free to describe this in your first PR or on the
   mailing list, but note that it will be much easier to review changes
   if they affect smaller portions of code at a time.

2. **Keep commits brief and clean**: This gem uses Git and tries to maintain a
   clean repository. Please ensure that you use [commit conventions][commit]
   to make things nice and neat both in the description and commit history.
   Specifically, consider squashing commits if you have partial or complete
   reverts of code. Each commit should provide an atomic change that moves
   the project forwards, not back. Any changes that only fix other parts of
   your PR should be hidden from the commit history.

3. **Follow our coding conventions**. This gem uses typical Ruby source formatting,
   though it occasionally has minor differences with other projects you may
   have seen. Please look through a few files (at least the file you are
   editing) to ensure that you are consistent in the formatting your PR is
   using.

If your change is large, consider opening an issue to ask a question; 
we will be happy to have a conversation and let you know if the feature
would be considered. They usually are, but it might be prudent to ask first!

[issues]: http://github.com/rhuanbarreto/ip21-ruby/issues
[commit]: http://chris.beams.io/posts/git-commit/
[pr]: https://help.github.com/articles/using-pull-requests/