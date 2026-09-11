# Nikhilvarma Kandula

Founder and AI engineer, based in Germany.

<sub>Also written as Nikhil Varma Kandula · Kandula Nikhilvarma · Nikhilvarma K</sub>

I build AI products and I keep them running. Six are live. The table below links to each
one, and every link opens the real thing.

Before I built my own products, I spent eighteen months at a US fintech. I rebuilt a
monolith into event-driven services for more than 500 concurrent users. I went from data
engineer to lead developer there. I also built an LLM audit pipeline. It cut fifteen hours
of weekly manual review to about three.

I am now doing an M.Sc. in Big Data and Business Analytics at FOM Hochschule, until August
2027. I have one peer-reviewed paper, on rainfall estimation by data fusion.

Every project below has a written case study. Each one states what the thing does, how it
is put together, and what each decision cost. They are at
**[kandula.studio](https://kandula.studio)**.

---

## Live products

| Product | What it does | Links |
|---|---|---|
| **Ganymede** | Decides which delinquent borrower is worth an agent-minute, then coaches the call that follows. It ranks accounts by the money a call recovers, not by the chance the borrower defaults. | [Live](https://ganymede-kandula.vercel.app) · [Code](https://github.com/kandulanikhilvarma/ganymede) · [Case study](https://kandula.studio/work/ganymede/) |
| **Witness** | Turns a photograph of a returned gearbox part into a failure record. The record names the ISO damage mode, the severity, the cause, and the batch that made the part. The model suggests. The inspector decides. | [Live](https://witness-kandula.vercel.app) · [Code](https://github.com/kandulanikhilvarma/witness) · [Case study](https://kandula.studio/work/witness/) |
| **FirstChair** | Measures how ChatGPT, Gemini and Perplexity describe a law firm against its named competitors. It samples each model many times and reports a distribution, because one query of a non-deterministic system is an anecdote. | [Live](https://thefirstchair.vercel.app) · [Code](https://github.com/kandulanikhilvarma/firstchair) · [Case study](https://kandula.studio/work/firstchair/) |
| **Cartwise** | Reads a photographed grocery receipt and returns a nutrition summary. The receipt is already itemised, so the user logs one thing instead of thirty. | [Live](https://cartwise-nine.vercel.app) · [Code](https://github.com/kandulanikhilvarma/cartwise) · [Case study](https://kandula.studio/work/cartwise/) |
| **Bud** | Tracks habits the way a game does. The reward lands at the moment you complete the habit, and a missed day decays the streak instead of erasing it. | [Live](https://buddd.vercel.app) · [Code](https://github.com/kandulanikhilvarma/bud) · [Case study](https://kandula.studio/work/habit-game/) |
| **Knock** | Books local services from both sides of one calendar. Choosing a time submits a claim on a slot, so two customers can never both be told yes. | [Live](https://services-app-zeta.vercel.app) · [Case study](https://kandula.studio/work/doorstep/) |

## Research and production systems

- **[Rainfall estimation via heterogeneous data fusion](https://kandula.studio/work/rainfall-paper/)**
  Peer-reviewed, IRJMETS Vol 7 Issue 3. It fuses ground sensors, radar and satellite imagery
  into one estimate. Probability of detection is 0.58, above the Kriging baseline on the same
  evaluation set.
- **[Fintech real-estate intelligence system](https://kandula.studio/work/microintech/)**
  Eighteen months at MicroIntech. A monolith became event-driven services for more than 500
  concurrent users, at 100% transaction integrity. The repository is private, so the case
  study is the record.

## Data investigations

| Project | What it found | Stack | Case study |
|---|---|---|---|
| [German tech job market](https://github.com/kandulanikhilvarma/skill-demand-deutschland-tech-market) | Python and SQL appear together in 65% of 3,200 validated German postings. A gazetteer extractor pulled 156 skills at 88.4% precision. Four role clusters separate at a silhouette of 0.61. | Python · spaCy · TF-IDF | [Read](https://kandula.studio/work/deutschland-nlp/) |
| [Rider segmentation and growth](https://github.com/kandulanikhilvarma/rider-segmentation-growth) | Casual riders are not unconverted members. They ride 1.63 times longer than members and drop 93% on weekdays, which makes a membership discount the wrong offer. | SQL · BigQuery · Tableau | [Read](https://kandula.studio/work/cyclistic/) |
| [US flight delay analysis](https://github.com/kandulanikhilvarma/flight-delay-analysis) | Across 2.91 million flights, 41.1% of delay minutes come from the aircraft arriving late on its previous leg. That is more than weather, NAS, carrier and security together. | Python · Jupyter | [Read](https://kandula.studio/work/flight-delay/) |
| [Quantifying data quality](https://github.com/kandulanikhilvarma/quantifying-data-quality) | Four dimensions scored on 9,357 sensor records give a composite index of 0.840. Timeliness is the only failing dimension at 0.626, and it is the one most frameworks leave out. | Python · spaCy · scikit-learn | [Read](https://kandula.studio/work/data-quality/) |
| [E-commerce return rates](https://github.com/kandulanikhilvarma/return-rate-analysis) | 541,000 transactions segmented by category, price band and customer, read against Germany's 92 billion euro returns problem. | Python · BI | [Read](https://kandula.studio/work/return-rate/) |
| [ESG and GDP growth](https://github.com/kandulanikhilvarma/esg-gdp-regression) | A published null result. Across 38 OECD countries and eleven years, the model explains almost none of the variance in growth, at an R-squared of 0.004. | Python · Jupyter | [Read](https://kandula.studio/work/esg-gdp/) |
| [Manufacturing cost variance](https://github.com/kandulanikhilvarma/manufacturing-cost-variance-qlik) | A controlling dashboard with a fixed reading order: over or under, getting worse or not, and where from. 33 tests cover the variance arithmetic. | Qlik · Python | [Read](https://kandula.studio/work/qlik-cost-variance/) |

## Numbers, and where each one comes from

Every figure here links to the work that produced it. None of them is rounded up.

| Figure | What it measures | Source |
|---|---:|---|
| 5.5 million | Bike-share trips read in BigQuery | [Rider segmentation](https://kandula.studio/work/cyclistic/) |
| 2.91 million | US flights analysed, 2019 to 2023 | [Flight delay](https://kandula.studio/work/flight-delay/) |
| 541,000 | Retail transactions segmented | [Return rates](https://kandula.studio/work/return-rate/) |
| 9,357 | Sensor records scored, composite index 0.840 | [Data quality](https://kandula.studio/work/data-quality/) |
| 3,200 | German postings validated, 156 skills at 88.4% precision | [Job market](https://kandula.studio/work/deutschland-nlp/) |
| 500+ | Concurrent users served at 100% transaction integrity | [MicroIntech](https://kandula.studio/work/microintech/) |
| 0.58 | Probability of detection, peer-reviewed | [Rainfall paper](https://kandula.studio/work/rainfall-paper/) |
| +59% | Recovered value per agent-minute over risk-ranking | [Ganymede](https://kandula.studio/work/ganymede/) |

## What I work with

| Area | Tools and methods |
|---|---|
| AI and LLM | LLM orchestration, retrieval-augmented generation, prompt engineering, LLM audit pipelines, generative engine optimisation |
| Product engineering | TypeScript, Next.js, React, Supabase, Prisma, Vercel |
| Data engineering | Python, Polars, pandas, SQL, BigQuery, event-driven architecture, microservices |
| Data science | LightGBM, scikit-learn, spaCy, calibration, uplift modelling, statistical testing |
| Analytics | Tableau, Qlik Sense, Power BI, dashboard design |

## Where to find me

| | |
|---|---|
| Portfolio | [kandula.studio](https://kandula.studio) |
| GitHub | [@kandulanikhilvarma](https://github.com/kandulanikhilvarma) |
| LinkedIn | [in/nikhilvarmakandula](https://www.linkedin.com/in/nikhilvarmakandula) |
| ORCID | [0009-0000-1331-5771](https://orcid.org/0009-0000-1331-5771) |
| Google Scholar | [Publications](https://scholar.google.com/citations?user=_-uJC6YAAAAJ) |
| Medium | [@kandulanikhilvarma](https://medium.com/@kandulanikhilvarma) |
| Substack | [@nikhilvarmakandula](https://substack.com/@nikhilvarmakandula) |
| Tableau Public | [nikhilvarma.kandula](https://public.tableau.com/app/profile/nikhilvarma.kandula) |
| Kaggle | [nikhilvarmakandula](https://www.kaggle.com/nikhilvarmakandula) |
| Email | [kandulanikhilvarma@gmail.com](mailto:kandulanikhilvarma@gmail.com) |

---

Open to AI, data and software engineering roles anywhere in Germany, and to full-time roles
in India. Available now, 20 hours a week on a student visa in Germany.

[LinkedIn](https://www.linkedin.com/in/nikhilvarmakandula) ·
[Email](mailto:kandulanikhilvarma@gmail.com) ·
[Portfolio](https://kandula.studio)
