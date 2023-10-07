## Writing style guidelines

1. {: #american-english} At GitLab, we use American English as the standard written language.
2. Do not use rich text, it makes it hard to copy/paste. Use [Markdown](/handbook/markdown-guide/) to format text that is stored in a Git repository. In Google Docs use "Normal text" using the style/heading/formatting dropdown and paste without formatting.
3. Do not use ALL CAPS because it [feels like shouting](https://en.wikipedia.org/wiki/All_caps#Association_with_shouting). However, there is the [`#all-caps` Slack channel](https://gitlab.slack.com/archives/C01BC085AVB) for your good-natured shouting needs.
4. We use Unix style (lf) line endings, not Windows style (crlf), please ensure `*.md text eol=lf` is set in the repository's `.gitattributes` and run `git config --global core.autocrlf input` on your client.
5. Always write a paragraph on a single line. Use soft breaks ("word wrap") for readability. Do not put in a hard return at a certain character limit (e.g., 80 characters) and don't set your IDE to automatically insert hard breaks. Merge requests for the blog and handbook are very difficult to edit when hard breaks are inserted.
6. Do not create links like "here" or "click here". All links should have relevant anchor text that describes what they link to, such as: "GitLab CI source installation documentation". Using [meaningful links](https://www.futurehosting.com/blog/links-should-have-meaningful-anchor-text-heres-why/){:rel="nofollow noindex"} is important to both search engine crawlers (SEO) and accessibility for people with learning differences and/or physical disabilities. This guidance should be followed in all places links are provided, whether in the handbook, website, GoogleDocs, or any other content. Avoid writing GoogleDocs content which states - `Zoom Link [Link]`. Rather, paste the full link directly following the word `Zoom`. This makes the link more prominent and makes it easier to follow while viewing the document.
7. When specifying measurements, please include both Metric and Imperial equivalents.
8. Although we're a San Francisco based company we're also an internationally diverse one. Please do not refer to team members outside the US as international, instead use non-US. Please also avoid the use of offshore/overseas to refer to non-American continents.
9. If you have multiple points in a comment or email, please number them. Numbered lists are easier to reference during a discussion over bulleted lists.
10. When you reference an issue, merge request, comment, commit, page, doc, etc. and you have the URL available please paste that in.
11. In making URLs, always prefer hyphens to underscores, and always use lowercase.
12. The community includes users, contributors, core team members, customers, people working for GitLab Inc., and friends of GitLab. If you want to refer to "people not working for GitLab Inc." just say that and don't use the word community. If you want to refer to people working for GitLab Inc. you can also use "the GitLab Inc. team" but don't use the "GitLab Inc. employees".
13. When we refer to the GitLab community excluding GitLab team members please say "wider community" instead of "community".
14. All people working for GitLab (the company) are the [GitLab team](/company/team/). We also have the [Core team](/community/core-team/) that consists of volunteers.
15. Please always refer to GitLab Inc. people as GitLab team members, not employees.
16. Use [inclusive and gender-neutral language](https://techwhirl.com/gender-neutral-technical-writing/) in all writing.
17. Always write "GitLab" with "G" and "L" capitalized, even when writing "GitLab.com", except within URLs. When "gitlab.com" is part of a URL it should be lowercase.
18. Refer to products by tier name only on Marketing pages: Our tier names are Ultimate, Premium, and Free. When both deployment models are being referred to (SaaS and self-managed), use the tier name only. When only one of the deployment models is being referred to, prefix the tier name with the deployment model. E.g., SaaS-Premium, Self-Managed-Ultimate.
19. Correct capitalization of self-managed: The term `self-managed` should not be capitalized unless it's in a title or unless you are writing the full product name ("Self-Managed-Ultimate"). If it is used at the beginning of a sentence, then the first word only is capitalized: "Self-managed".
20. Refer to environments that are installed and run by the end-user as "self-managed."
21. Write a [group](/handbook/product/categories/#hierarchy) name as ["Stage:Group"](/handbook/product/categories/#naming) when you want to include the stage name for extra context.
22. Do not use a hyphen when writing the term "open source" except where doing so eliminates ambiguity or clumsiness.
23. Monetary amounts shouldn't have one digit, so prefer $19.90 to $19.9.
24. If an email needs a response, write the answer at the top of it.
25. Use the future version of words, just like we don't write internet with a capital letter anymore. We write frontend and webhook without a hyphen or space.
26. Our homepage is https://about.gitlab.com/ (with the `about.` and with `https`).
27. Try to use the [active voice](https://writing.wisc.edu/Handbook/CCS_activevoice.html) whenever possible.
28. If you use headers, properly format them (`##` in Markdown, "Heading 2" in Google Docs); start at the second header level because header level 1 is for titles. Do not end headers with a colon. Do not use emoji in headers as these cause links to have strange characters.
29. Always use a [serial comma](https://en.wikipedia.org/wiki/Serial_comma) (a.k.a. an "Oxford comma") before the coordinating conjunction in a list of three, four, or more items.
30. Always use a single space between sentences rather than two.
31. Read our [Documentation Styleguide](https://docs.gitlab.com/ee/development/documentation/styleguide/) for more information when writing documentation.
32. Do not use acronyms when you can avoid them. Acronyms have the effect of excluding people from the conversation if they are not familiar with a particular term. Example: instead of `MR`, write `merge request (MR)`.
    1. If acronyms are used, expand them at least once in the conversation or document and define them in the document using [Kramdown abbreviation syntax](https://kramdown.gettalong.org/syntax.html#abbreviations). Alternatively, link to the definition.
    2. If you don't know the meaning of an acronym, ask. It's always ok to [speak up](/handbook/values/#share).
33. We segment our customers/prospects into 4 segments [Strategic, Large, Mid-Market, and Small Medium Business (SMB)](/handbook/sales/field-operations/gtm-resources/).

## Simple language

{: #simple-language}

Simple Language is meant to encourage everyone at GitLab to simplify the language we use. We should always use the most clear, straightforward, and meaningful words possible in every conversation. Avoid using "fluff" words, jargon, or "corporate-speak" phrases that don't add value.

When you **don't** use Simple Language, you:

- Confuse people and create a barrier for participants of your conversation.
- Cause others to not speak up in a meeting because they don't understand what you're saying.
- Are not inclusive of those whose first language is not English.
- Do not add value with your words.

When you **do** use Simple Language, you:

- Get work done more efficiently.
- Build credibility with your audience (your team, coworker, customer, etc.).
- Keep people's attention while you're speaking.
- Come across more confident and knowledgeable.

**Here's an example:**

*Original sentence*

> We're now launching an optimization of our approach leveraging key learnings from the project's postmortem.

*A Simple Language sentence*

> We're creating a new plan based on what we learned from this project.

Simple Language is important both when we're speaking to other team members and when we're representing GitLab to people outside the company.

Be sure to use Simple Language in written communications as well. Our handbook, website, docs, marketing materials, and candidate or customer emails should be clear, concise, and effective. Corporate marketing maintains guidelines on [GitLab's tone of voice](https://design.gitlab.com/brand/overview#tone-of-voice).

| Instead of...                       | Try...                                        |
|-------------------------------------|-----------------------------------------------|
| Getting buy-in/Getting alignment    | Asking for feedback since DRIs make decisions |
| Synergy                             | Effective Collaboration                       |
| Get all your ducks in a row         | Be organized                                  |
| Do not let the grass grow too long  | Work quickly                                  |
| Leverage                            | Use more explicit phrasing- debt, etc.        |
| Send it over the wall               | Share it with a customer                      |
| Boil the ocean                      | Waste time                                    |
| Punt                                | Make less of a priority                       |
| Helicopter view/100 foot view       | A broad view of the business                  |
| Turtles all the way down            | Cascade through the organization              |
| When someone has spare/extra cycles | When someone is available                     |

### Inefficient things shouldn't sound positive

For example, do not suggest that you're "working in real-time" when a matter is in disarray. Convey that a lack of organization is hampering a result, and provide feedback and clear steps on resolving.

Do not use a cool term such as "tiger team" when the [existing term of "working group"](/company/team/structure/working-groups/) is more exact. While cool terms such as these may be useful for persuading colleagues to join you in working towards a solution, the right way isn't to use flowery language.

The last example is when we used 'Prioritizing for Global Optimization' for what we now call a [headcount reset](/handbook/product/product-processes/#headcount-resets). When we [renamed it](https://gitlab.com/gitlab-com/www-gitlab-com/-/merge_requests/31101/diffs) we saw a good reduction in the use of this disruptive practice of moving people around.
