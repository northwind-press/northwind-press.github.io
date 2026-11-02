---
title: "TypeScript 7.1 beta types imports by attribute, tightens distributive conditional types"
author: "Software & Dev Reporter"
description: "Try TypeScript 7.1 beta with npm install -D typescript@beta, and check type-level code for new errors in distributive conditional types before the stable release."
categories: [software]
kind: news
date: 2026-11-02 22:37
sources:
  - title: "Announcing TypeScript 7.1 Beta"
    url: https://devblogs.microsoft.com/typescript/announcing-typescript-7-1-beta/
    publisher: "Daniel Rosenwasser, Microsoft TypeScript team"
    date: "2026-10-20"
    accessed: "2026-11-02"
  - title: "TypeScript 7.1 Iteration Plan"
    url: https://github.com/microsoft/TypeScript/issues/63703
    publisher: "microsoft/TypeScript on GitHub"
    accessed: "2026-11-02"
corrections: []
---

Microsoft released the [TypeScript 7.1 beta](https://devblogs.microsoft.com/typescript/announcing-typescript-7-1-beta/) on 2026-10-20. It lets ambient module declarations match on import attributes, makes conditional types stricter, and adds an `es2026` target{% include cite.html n=1 %}. The beta also ships a new compiler API, and the team reports faster builds than 7.0 with lower memory use{% include cite.html n=1 %}.

## Import attributes in ambient modules

Projects that import CSS, text, or binary files have typed them with wildcard declarations such as `declare module "*.css"`, which ignore import attributes entirely{% include cite.html n=1 %}. In 7.1, a declaration can match on the attribute instead: `declare module "*" with { type: "text" }` types every import that uses `with { type: "text" }`, and imports that leave out a required attribute get an error{% include cite.html n=1 %}. TypeScript does not check that these files exist on disk, and it does not ship the declarations itself{% include cite.html n=1 %}. The team advises libraries not to publish them, so applications must write their own{% include cite.html n=1 %}.

## Changes that can break existing builds

- **Stricter checks on distributive type parameters.** Inside a conditional type that distributes over a union, TypeScript 7.1 treats the distributed type parameter as a new, narrower type, unrelated to other parameters constrained to the original{% include cite.html n=1 %}. Code that passed a constrained parameter into such a branch can now fail with "Type 'B' does not satisfy the constraint 'A'"{% include cite.html n=1 %}. The fix is to remove the constraint if it isn't needed, or to add conditional checks that satisfy it{% include cite.html n=1 %}.
- **Updated DOM types.** Regenerated `lib.d.ts` declarations for the DOM may change type-checking results{% include cite.html n=1 %}.

## New target and library types

`es2026` is now a stable `--target` and `--lib` value{% include cite.html n=1 %}. Its library adds declarations including `Math.sumPrecise()`, `Error.isError()`, `Map.prototype.getOrInsert()`, `Array.fromAsync()`, and base64 and hex methods on `Uint8Array`, some moved from `esnext`{% include cite.html n=1 %}.

## Schedule

The post says a release candidate is due in about a month, with the final release shortly after{% include cite.html n=1 %}. As of 2026-11-02, the [7.1 iteration plan](https://github.com/microsoft/TypeScript/issues/63703) lists the RC for 2026-11-10 and the stable release for 2026-11-24. The same plan lists the beta for 2026-10-06{% include cite.html n=2 %}; it shipped on 2026-10-20{% include cite.html n=1 %}.

## What to do

Our advice: install the beta in a branch with `npm install -D typescript@beta` and run your usual type check{% include cite.html n=1 %}. Look first for new constraint errors in conditional types, and for DOM type changes. If you type CSS, text, or binary imports with wildcard declarations, you can switch to declarations that match on attributes, but keep them in your application, not in published packages{% include cite.html n=1 %}. Report regressions to the team before the RC; the post asks for feedback on the beta{% include cite.html n=1 %}.
