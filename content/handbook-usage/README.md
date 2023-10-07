## Flow Structure

1. A (process) problem comes up, frequently in an issue or chat.
2. A proposal is made in a merge request to the handbook.
3. Once merged, the change is announced by linking to the diff in the MR or commit. Major and Medium ones are posted in the #team-monitoring channel for visibility, with a one line summary of the change. If there was an issue, close it out with a link to the diff.

Sometimes you want to have real time editing of a proposal during a meeting and you need to use a Google Doc for that. When doing so the first item should be the URL of the handbook page this content will be moved to when the meeting is over.

## Why handbook first

Documenting in the handbook before taking an action may require more time initially because you have to think about where to make the change, integrate it with the existing content, and then possibly add to or refactor the handbook to have a proper foundation. But, it saves time in the long run, and this communication is essential to our ability to continue scaling and adapting our organization.

This process is not unlike writing tests for your software. Only communicate a (proposed) change via a change to the handbook; don't use a presentation, email, chat message, or another medium to communicate the components of the change. These other forms of communication might be more convenient for the presenter, but they make it harder for the audience to understand the context and the implications for other potentially affected processes.

Having a **"handbook first"** mentality ensures there is no duplication; the handbook is always up to date, and others are better able to contribute.

Beyond being "handbook first," we are also "public handbook first." When information is [internal-only](communication/confidentiality-levels/#internal), it should be captured in the internal handbook, but we default to the public handbook for anything that can be [made public](communication/confidentiality-levels/#not-public). This ensures that everyone has access to any information that can be [SAFEly](legal/safe-framework/) shared. This supports the [RedHat values](https://www.redhat.com/en/about/brand/standards/culture), including freedom, accountability, and commitment. It also protects against the internal handbook becoming a home for information that should otherwise be public or a conflicting or duplicative source of truth.

When asked during an [INSEAD](http://insead.edu/) case study interview about challenges related to being all-remote, GitLab co-founder and CEO Sid Sijbrandij provided the following reply.

> The biggest problem is GitLab not working handbook first. We have an amazing handbook that allows us to collaborate, onboard new people, and think collectively.
>
> However, it is counterintuitive to communicate changes to the handbook. The default of people, when they wish to communicate a change, is to send a Slack message, send an email, give a presentation, or tell people in a meeting — *anything* but make a change in the handbook.
>
> It's slower for them. It's quicker to use any other form. If they make a change in the handbook, they first have to find the relevant part of the handbook, they sometimes have to adjust the handbook to make sure their change will fit in, they have to go through a technical process and a review or two, and they have to wait a bit before it's deployed.
>
> It's slower than any other option. However, it allows people that commit a change after that to build upon a change. When they take that extra time, it's building a foundation for the next thing.
>
> I think of it as brick laying. Every piece of information is a brick. At GitLab, there is a well-structured house, and everyone adds to that one house. Because we're pretty particular on how we build it, it has a strong foundation and we can build it very high.
>
> In every other company, they send the brick into the hands of people. Everyone is receiving bricks daily that they have to add to the house they're building internally. They forget things and things are unclear. A lot of context has to be created because there is no context around where to place the bricks.
>
> So, you can end up with a thousand houses that look quite different, that are all hanging a bit, and each time you add a brick to the top one pops out at the bottom. — *GitLab co-founder and CEO Sid Sijbrandij*

## Handbook guidelines

Please follow these guidelines and remind others of them.

### How we use the guide every day

1. Most guidelines in this handbook are meant to help, and unless otherwise stated, are meant to help more than being absolute rules. Don't be afraid to do something because you don't know the entire handbook, nobody does. Be gentle when reminding people about these guidelines. For example say, "It is not a problem, but next time please consider the following guideline from the handbook."
2. If you ask a question and someone answers with a link to the handbook, they do this because they want to help by providing more information. They may also be proud that we have the answer documented. It doesn't mean that you should have read the entire handbook, nobody knows the entire handbook.
3. If you need to ask a team member for help, please realize that there is a good chance the majority of the community also doesn't know the answer. Be sure to **document** the answer to radiate this information to the whole community. After the question is answered, discuss where it should be documented and who will do it. You can remind other people of this request by asking "Who will document this?"
4. When you discuss something in chat always try to **link** to a URL where relevant. For example, the documentation you have a question about or the page that answered your question. You can remind other people of this by asking "Can you please link?"
5. Remember, the handbook is not what we hope to do, what we should formally do, or what we did months ago. **It is what we do right now.** Make sure you change the handbook in order to truly change a process. To propose a change to a process, make a merge request to change the handbook. Don't use another channel to propose a handbook change (email, Google Doc, etc.).
6. The handbook is the process. Any sections with names like 'process', 'policies', 'best practices', or 'standard operating procedures' are an indication of a deeper problem. This may indicate a duplication between a prose description of a process and a numbered list description of the same process that should be combined in one description of the process.
7. When communicating something always include a link to the relevant (and up-to-date) part of the **handbook** instead of including the text in the email/chat/etc. You can remind other people of this by asking "Can you please link to the relevant part of the handbook?"
8. Everyone should subscribe to the `#handbook` channel to stay up-to-date with changes to the handbook

### How to change or define a process

1. To change a guideline or process, **suggest an edit** in the form of a merge request.
2. When working to get your change merged quickly, make sure you are asking the appropriate team members with merge rights. Not sure who is responsible? Consult (and add to) the `CODEOWNERS` [repository](https://github.com/rhobs/handbook/-/blob/master/.github/CODEOWNERS).
3. After it is merged you can post this in the `#team-monitoring` slack channel if applicable. You can remind other people of this by asking "Can you please send a merge request for the handbook?"
4. When substantially changing handbook layout, please leave a link to the specific page of the review app **that is directly affected by this MR**. Along with the link, include as much info as possible in the MR description. This will allow everyone to understand what is the purpose of the MR without looking at diffs.
5. Keeping up with changes to the Handbook can be difficult, please follow the [commit subject guidelines](https://docs.gitlab.com/ee/development/contributing/merge_request_workflow.html#commit-messages-guidelines) with a particular focus on your merge request's title.
6. Communicate process changes by linking to the **merged diff** (a commit that shows the changes before and after). If you are communicating a change for the purpose of discussion and feedback, it is ok to link to an **unmerged diff**. Do not change the process first, and then view the documentation as a lower priority task. Planning to do the documentation later inevitably leads to duplicate work communicating the change and it leads to outdated documentation. You can remind other people of this by asking "Can you please update the handbook first?"
7. When feasible, introduce process changes iteratively. It is important that you contribute to the handbook by making small merge requests. This will help gain adoption among the process's intended audience. We want to avoid significant process changes that are unnecessarily large, top-down, and disruptive. These types of process changes can disempower directly responsible individual and cause people to focus on process rather than results.
8. Like everything else, our processes are always in flux. Everything is always in draft, and the initial version should be in the handbook, too. If you are proposing a change to the handbook, whenever possible, **skip the issue and submit a merge request**. (Proposing a change via a merge request is preferred over an issue description). Mention the people that are affected by the change in the merge request. In many cases, merge requests are easier to collaborate on since you can see the proposed changes.
9. **If something is a limited test** to a group of users, add it to the handbook and note as such. Then remove the note once the test is over and every case should use the new process.
10. If someone inside or outside RedHat makes a good suggestion invite them to add it to the handbook. Send the person the URL of the relevant page and section and offer to do it for them if they can't. Having them make and send the suggestion will make the change and will reflect their knowledge.
11. When you submit a merge request, make sure that it gets merged quickly. Making single, small changes quickly will ensure your branch doesn't fall far behind master, creating merge conflicts. Aim to make and merge your update on the same day. Mention people in the merge request or reach them via Slack. If you get a suggestion for a large improvement on top of the existing one consider doing that separately. Create an issue, get the existing MR merged, then create a new merge request.
12. If you have to move content have a merge request that moves it and does nothing else. If you want to clean it up, summarize it, or expand on it do that after the moving MR is merged. This is much easier to review.
13. Try to **add the why of a handbook process**, what is the business goal, what is the inspiration for this section. Adding the why makes processes easier to change in the future since you can evaluate if the why changed.

### Style guide and information architecture

#### Single Source of Truth

Think about the information architecture to eliminate repetition and have a Single Source of Truth (SSoT). Instead of repeating content cross-link it (each text has a hyperlink to the other piece). If you copy content please remove it at the origin place and replace it with a link to the new content. Duplicate content leads to more work by having to update the content in multiple places as well as the need to remember where all of the out of date content lives. When you have a single source of truth it's only stored in a single system. Make sure to always cross-link items if there are related items (elsewhere in the handbook, in docs, or in issues).

#### System of Record

A system of record (SoR) is the authoritative data source for a given data element or piece of information. It's worth noting that while it is possible to have a system of record that is also a single source of truth, simply just being a system of record doesn't directly imply it is the single source of truth.

#### Organized by Function and Results

The handbook is **organized by function and result** to ensure every item in it has a location and owner to keep it up to date.

- It's essential that we adhere to this hierarchy and that we not maintain separate structures for company training materials (e.g. onboarding materials, how-tos, etc.), videos, or other documentation.
- Adhering to this hierarchy is sometimes counter-intuitive. We've learned over the years that keeping content in context helps to ensure consistency when making future updates.
- At times, a change of perspective may be desired. In those cases, link to relevant sections of the handbook but don't include the content itself.

#### Avoid unstructured content

- **Avoid unstructured content based on formats like Learning Playbooks, [FAQs](https://idratherbewriting.com/2017/06/23/why-tech-writers-hate-faqs/), lists of links (such as quick links), resource pages, glossaries, courses, videos, tests, processes, standard operating procedure, training, or how-to's.** These are very hard to keep up-to-date and are not compatible with organization per function and result. For example: Call it Contract Negotiation Handbook instead of Contract Negotiation Playbook
- Instead, put the answer, link, definition, course, video, or test in the most relevant place. Use descriptive headings so that people can easily search for content.
- That said, please mix *formats* where and when appropriate in the handbook, even within a single page. Utilizing multiple formats can be valuable, and different people may prefer certain formats over others.
- Worry only about the organization **per function and result**, not about how the page will look if you embed varying types and formats of content.

#### Use headings liberally

Headings should have normal capitalization: don't use [ALL CAPS](https://en.wikipedia.org/wiki/All_caps) or [TitleCase](http://www.grammar-monster.com/glossary/title_case.htm). After a heading, leave one blank line; this is [not required in the standard](http://spec.commonmark.org/0.27/#example-46), but it is our convention.

### Editing the handbook

Please read through the [Writing Style Guidelines](/handbook/communication/#writing-style-guidelines) before contributing.

#### Fine points

- Keep your handbook pages short and succinct. Eliminate fluff and get right to the point with the shortest possible wording. Keep in mind that the biggest challenge cited by new employees is the vast amount of information to take in during on-boarding.
- We don't need [.gitkeep files](https://stackoverflow.com/questions/7229885/what-are-the-differences-between-gitignore-and-gitkeep) in our handbook, they make it harder to quickly open a file in editors. Don't add them, and delete them when you see them.

### Scope of this handbook

- All documentation that also applies to code contributions from the wider community should be in the it's respective projects, not the Handbook, which is only for team members. Read more in the [Documentation](../documentation/) section of the Handbook.
- The handbook is for things concerning current and future RedHat team-monitoring members only. If something concerns users of RedHat products, it should be documented in the official documentation of the product or in the opensource project.

### Handbook First Competency

In an all-remote, asynchronous organization, each team member should practice handbook first. For more information on what it means to be handbook first, please refer to the [why handbook first](/handbook-usage/#why-handbook-first) section of this page.

**Skills and behaviors of handbook first as a Team Member**:

- Actively contributes to the handbook.
- [Start with a merge request](/handbook/communication/#start-with-a-merge-request)
- Provides links information from the handbook when answering questions and if the information doesn't exist in the handbook, then the team member adds it.
- Understands which information is internal-only, but puts all public information in the public handbook.

**Skills and behaviors of handbook first as a People Leader**:

- Holds their team and others accountable for being handbook first.
- Demonstrates leadership in being public handbook first with all information that is not internal-only.
- Enables new team members and managers on how to leverage the handbook as a resource.
- Serves as a role model for what it means to be handbook first.

### The Internal handbook

TODO (JoaoBraveCoding) As an attempt to try and make the first iteration of the handbook as brief as possible we will introduce the internal handbook on a latter date.

## Management

It is each department and team member's responsibility to ensure the handbooks (public handbook, internal handbook, and staging handbook) stay current. The content in the handbook should be accurate and follow the same format as outlined in the [Guidelines](#handbook-guidelines). For questions on who to submit a merge request to, or assistance with the handbook, please reach out on the `#team-monitoring` Slack channel.

## Screenshot the handbook instead of creating a presentation

Presentations are great for ephemeral content like group conversations and board presentations. [Evergreen content](https://www.michaelbellone.co.uk/blog/the-do-and-donts-of-evergreen-content/) like a leadership training should be based on the handbook. This is an important element of working handbook-first.

In the creation of presentations for evergreen content, please screenshot the handbook and provide links to displayed pages rather than copy and pasting content (or formatting a slide specifically to mirror handbook information). This approach shows a bias towards asynchronous communication, and rationale for this is below.

1. It saves you the effort of needing to both update the handbook and create content for a presentation; the handbook is checked and improved as part of the preparation instead of extra work
2. The handbook will stay up to date so people don't look at an outdated information in a presentation
3. Seeing screenshots will confirm to people the content is in the handbook and it is up to date there
4. People get used to the structure of the handbook and can more easily find the relevant handbook section later on
5. The content is open for everyone to contribute to when it is in the handbook
6. The content is integrated with the rest of our processes and shown in context
7. Many more people will consume the content on a webpage than a presentation because it is easier to search and link
8. You're helping other organizations and students around the work by giving them an example how we do it

The presentation will look less polished, but the advantages outweigh that concern.

If a synchronous presentation is required, default to sharing your screen and viewing live handbook pages over a slide presentation.

## Make it worthwhile

Companies asked how GitLab managed to work with the handbook because at their company it wasn't working: "There are many occasions where something is documented in the knowledge base, but people don't know about it because they never bothered to read or search. Some people have a strong aversion against what they perceive as a 'wall of text'."

There is an attempt to cover this in GitLab's [guide to embracing a handbook-first approach to documentation](https://about.gitlab.com/company/culture/all-remote/handbook-first-documentation/).

To ensure that people's time is well spent looking at the handbook we should follow the 'handbook guidelines' above, and also:

1. Follow the [writing style guide](/communication/#writing-style-guidelines)
2. Make it public so you can Google search
3. Test people on their knowledge during onboarding
4. Give real examples
5. Avoid corporate speak, describe things like you're talking to a friend. For more, see our communications guide on [Simple Language](/communication/#simple-language).

## Wiki handbooks don't scale

Company handbooks [frequently start as wikis](/company/culture/all-remote/handbook-first-documentation/#tools-for-building-a-handbook). This format is more comfortable for people to work in than a static website with GitHub Merge Requests and GitHub Pages. However wikis tend to go stale over time, where they are badly organized and get out of date.

In wikis it is impossible to make proposals that touch multiple parts of a page and/or multiple pages. Therefore it is hard to reorganize the handbook. Because GitHub Merge Requests and GitHub Pages are based on distributed version control you can split the role of submitter and approver. This allows for a division of work that keeps the handbook up to date:

- Anyone who can read the handbook can make a proposal
- Leaders (who tend to be short on time) only have to approve such a proposal

Wikis also do not encourage collaboration on changes, because there is no way to discuss a proposed change like there is with merge requests.

Some wikis make it hard to view and/or link to diffs of changes, which is needed to communicate decisions.

## External use of the Handbook

Our handbook is heavily inspired in GitLab's handbook, to this end please consider they stance on external use.

> Remember that, like virtually everything we do, our handbook is [open source](/solutions/open-source/), and we expect that other companies may use it as inspiration for their own documentation and practices. That said, the handbook should always be specific on **what we do**, not **who we want to be**, and every company will need to fill out their own handbooks over time. Our handbook falls under the [Attribution-ShareAlike 4.0 International license](https://creativecommons.org/licenses/by-sa/4.0/).

## Searching the Handbook

Every RedHat Handbook page has a search field near the top of the page for searching.

## Having Trouble Contributing to the Handbook?

If you run into trouble editing the RedHat Handbook there are various means of help available.

Team members, are available to help you create a merge request or debug any problems you might run into while updating the RedHat Handbook.

### Merge with confidence

Even if you are not a developer, you should feel confident merging any changes that pass the pipeline without worrying that you will break the handbook. The tests in the pipeline are designed to catch any major problems. The `handbook` project is configured so that changes cannot be merged unless the pipeline passes. When in doubt, feel free to loop in a technical reviewer. You can ask for help in the `#team-monitoring` slack channel. Senior team members can provide a technical review or help you fix a broken pipeline. In the event that code is merged that does break the handbook in some way, let the team know as soon as possible.

### When to get approval

Getting pinged to approve every small change to your page can be annoying, but someone changing a policy or procedure in the handbook without proper approval can have strong negative consequences. Use your best judgement on when to ask for approvals.

Whenever reasonable, practice [responsibility over rigidity](/handbook/values/#freedom-and-responsibility-over-rigidity). When you expect a page owner will appreciate your changes, go ahead and merge them without approval. Always ping the code owners with an @mention comment to inform them of the changes. They will be happy their page was made better and they didn’t need to waste time reviewing and approving the change. In the event that something isn’t an improvement, we practice [clean up over sign off](/handbook/values/#cleanup-over-sign-off).

Whenever appropriate, get approval from the [code owner](https://github.com/rhobs/handbook/-/blob/master/.github/CODEOWNERS) before merging changes. The page’s code owner is the DRI for the page and has the final say for what appears in the handbook. When in doubt, get the DRI’s permission before changing their page. Don't worry if the DRI is a senior level person. You can still assign your MRs to them, even if you are an individual contributor. This is because we prefer to communicate directly.

### Have a peer review your changes

Unless it’s a small change like a typo, always have another team member review your changes before you merge them.
