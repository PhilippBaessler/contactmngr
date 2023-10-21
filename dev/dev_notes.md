# Things to consider

-   where to save persistent configuration (per windows user?), such that I can access contacts using the miniUI regardless of the current working directory

-   how to manage notes per contact?

    -   either save as text within the json

    -   or, create a unique id, save that in the json, and create one \*.md file per person in a subdirectory linked via this unique id

    -   rendered markdown can be displayed within the miniUI (using maybe `markdown` package and `includeHTML()`

        -   it should then be possible to edit this markdown (e.g. edit button and then display the raw md content in a large text box)

        -   it should be possible to open the underlying md file directly in Rstudio and jump to it (possibly also remembering the cursor position?)

        -   some search and highlight capabilities? (maybe some javascript libs?)

    -   use h1 headers for year, h2 headers for month, h3 headers for "yyyy-mm-dd - \<matter/topic\>"\
        or better: h1 for year ("yyyy"), h2 for month ("yyyy-mm"), and each entry is then a collapsible element using

        ``` markdown
        <details>
        <summary><b>YYYY-MM-DD</b> (optional: matter/topic)</summary>

        notes etc.

        - Bullet
        - Points

        </details>
        ```

    -   maybe use rmd rather than md, as this could be rendered into html hat has some sort of accordion for headers or something else that can be expanded/collapsed?\
        or look at this: <https://gist.github.com/pierrejoubert73/902cc94d79424356a8d20be2b382e1ab>

    -   in a later version, these notes could be organized as objects, where each entry is one individual object

-   use flags and tags?

-   maybe use proper object orientation?

-   the fields:

    | field                | example                                                                 | has history |
    |----------------|-----------------------------------------|----------------|
    | surname              | {current: "Baessler", previous: {name: "...", until: "yyyy-mm-dd"}}     | yes         |
    | forename             | "Philipp"                                                               | no          |
    | middle_name          | ["foo", "bar"]                                                          | no          |
    | used_name            | "Philipp"                                                               | no          |
    | birthday             | 01.09.1991                                                              | no          |
    | siezen               | FALSE                                                                   | no          |
    | emails               | \<nested\>                                                              |             |
    | ⤷ private            | {email: ...., active: T, created: ...., is_main: T, modified: ...}      | yes         |
    | ⤷ business           | {email: ...., active: T, created: ...., is_main: T, modified: ...}      | yes         |
    | phone                | \<nested\>                                                              |             |
    | ⤷ private            | {phone: ...., active: T, created: ...., is_main: T, modified: ...}      | yes         |
    | ⤷ business           | {phone: ...., active: T, created: ...., is_main: T, modified: ...}      | yes         |
    | occupation           | {occupation: ...., active: T, created: ...., modified: ...}             | yes         |
    | employment           | {company: ..., department: ..., active: T, created: ..., modified: ...} | yes         |
    | first_encounter      | {notes: ..., date: ...}                                                 | no          |
    | skills_and_expertise | {competence: ..., level: \<1-4\>, notes: ...}                           | no          |
    | points               | -2...2                                                                  | no          |
    | ~~picture~~          | ~~base64~~                                                              | ~~no~~      |
    | history              | {{what: [fields], date:...}, {what: "creation", date:...}}              | yes         |
