# Onboading presentation for In Cluster team

This folder contains a presentation that every new member of the In Cluster team should see in their first few days.

## Goal

The goal of this presentation is to, not only, bring people onboard as swiftly as possible, but also to let them know what being part of the In Cluster team means. What are our responsibilities, where do we fit in the company, how do we want to work with each other and how do we want to be perceived by other teams.

New members must get to know these details as it helps them understand what our culture is and how things work. It not only gives identity to the team but also defines key interactions that otherwise would be open to interpretation/guessing.

## How it works

The main presentation is in the file `onboarding-presentation.md`, the presentation is built using [Marp](https://marp.app/) as it's an open source solution for markdown presentations that allows for great flexibility in the look of the presentation.

Under the folder `assets` we have some images that are used in the presentation. These images were drawn using the tool [Draw.io](https://app.diagrams.net/) as it allows us to export the diagram and have them also under version control (`onboarding-diagrams.drawio`).

### Exporting a Slide Deck

In order to export a Slide Deck with [Marp](https://marp.app/) you can either do it with the [marp-cli](https://github.com/marp-team/marp-cli) or with the [VisualStudio extension](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode).

#### marp-cli

npx (npm exec) is the best way to use the latest Marp CLI if you wanted one-shot Markdown conversion without installation.

```bash
npx @marp-team/marp-cli@latest content/Teams/in-cluster/onboarding/onboarding-presentation.md --pdf --html --allow-local-files
```

#### VisualStudio

After installing the [Marp VisualStudio extension](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode) don't forget to **enable HTML** in the Marp Visual Studio settings.

## Contributing

If you see anything outdated or that it should be corrected feel encouraged to open a PR :)
