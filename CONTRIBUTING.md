# Contributing

Contributions are highly encouraged!

To see what you can do, you can look at
[open issues](https://git.pattle.im/pattle/pattle/issues),
join [#pattle:matrix.org](https://matrix.to/#/#pattle:matrix.org),
[contact me directly](https://matrix.to/#/@wilko:matrix.org)!

When contributing code to Pattle, your code will be licensed under the
[AGPLv3](https://www.gnu.org/licenses/agpl-3.0.en.html).

## General contribution steps

1. Fork the project.
2. Create a feature/bug branch named, for example: `logout`.
3. Make your changes.
4. Add copyright notices
    1. If you have **edited** an existing file, add your copyright notice
       under the existing ones last, in the format of:
       ```
       Copyright (C) YEAR  Full Name <email@example.com>
       ```
       Note the double space between `YEAR` and `Full Name`.
    2. If you **created** a file, add the license file header with your name
       and email. (See [File headers](#file-headers))
5. Commit your changes and
   [create a merge request](https://git.pattle.im/pattle/pattle/merge_requests/new).

Note that if you're creating a new feature, you probably also need to implement
an API call in [Trace](https://git.pattle.im/pattle/library/android/trace).

## File headers

Every file has a license header with copyright notices. Every copyright
notice is in the format of: 
```
Copyright (C) YEAR  Full Name <email@example.com>
```
Note the double space between the year and full name.

The creator of the file is on top, and every contributor afterwards is
listed below in chronological order. An example file header would be:

```
// Copyright (C) 2018  Wilko Manger <wilko@rens.onl>
// Copyright (C) 2018  Nathan van Beelen <nathan@vanbeelen.org>
// 
// This file is part of Pattle.
// 
// Pattle is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Pattle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
// 
// You should have received a copy of the GNU Affero General Public License
// along with Pattle.  If not, see <https://www.gnu.org/licenses/>.

```

Here, `Wilko Manger` is the file creator, and `Nathan van Beelen` contributed later on.
