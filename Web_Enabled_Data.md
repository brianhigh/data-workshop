Data Management
========================================================

For Scientific Research

[//]: # (author: Jim Hogan, UW DEOHS)
[//]: # (date: 2014-06-24)
[//]: # (license: CC0 1.0 Universal, linked-content/images)
[//]: # (note: License does not apply to external content such as quoted material, linked web pages, images, or videos. These are licensed separately by their authors, publishers or other copyright holders. See attribution links for details.)
[//]: # (note: Any of the trademarks, service marks, collective marks, design rights, personality rights, or similar rights that are mentioned, used, or cited in the presentations and wiki of the Data Management For Scientific Research workshop/course are the property of their respective owners.)
[//]: # (homepage: https://github.com/brianhigh/data-workshop)

<p style="width: 600px; float: right; clear: right; margin-bottom: 5px; margin-left: 10px; text-align: right; font-weight: bold; font-size: 14pt;"><img src="http://www.stanza.co.uk/body/stanza_+BODY-copy.jpg" alt="stanza body copy" style="padding-bottom:0.5em;" />Photo: &copy; <a href="http://www.stanza.co.uk/body/index.html">Stanza</a>. Used with permission.</p>

Database-Driven Web Frameworks
========================================================

<p style="width: 800px; float: left; clear: right; margin-bottom: 5px; margin-left: 10px; text-align: right; font-weight: bold; font-size: 14pt;"><img src="https://raw.githubusercontent.com/mraible/history-of-web-frameworks-timeline/master/history-of-web-frameworks-timeline.png" alt="history of web frameworks timeline 2013" style="padding-bottom:0.5em;" />Image: <a href="https://github.com/mraible/history-of-web-frameworks-timeline"> Matt Raible
</a></p>

Frameworks: If they did not exist, you'd want to build your own.

Why did frameworks evolve?
==================================

* Reduce repetitive programming tasks
* Isolate error opportunities and reduce errors
* Improve potential securability
* Leverage collaborative development and contributed assets

A rough spectrum of frameworks
==================================

* High-Level
* Low/Language Level (IDEs)
* General Purpose (CMS)
* Learning Oriented (LMS)
* Purpose-driven (Wordpress)
* Document-oriented (DMS)
* Code generators
* WYSIWYG Editors (example: Dreamweaver)


Frameworks and the Web
==================================

* Frameworks may have existed before the advent of the World Wide Web
* Web-oriented tools^ evolved concurrently with the Web.
* The Web really launched what people think of as frameworks
* More recently, threats posed across the Internet and Web have made use of a framework almost compulsory.

^ PHP, 1995; Python 1989; Perl/CGI, 1997

Buzzword Side Note
==================================

People who talk about "framworks" also talk about "stacks".

Think about, for example, the [LAMP](http://en.wikipedia.org/wiki/LAMP_%28software_bundle%29)^ stack.

The concept of a stack provides a clearer understanding of separation of functions.


^ Linux, Apache, MySQL(MariaDB), PHP (/Perl/Python)

Should be LMAPP!
==================================

| Layer | Function |
| --- | ---- |
| Person | You |
| PHP/Perl/Python | App Delivery Scripting |
| Apache | Web Server |
| MySQL/MariaDB | Database |
| Linux | Operating System |

Factors in selecting a framework
===================================

* General goodness-of-fit/orientation
* Cost and learning curve
* Strength of technology, stability, APIs?
* Adoption, Community, and "Trajectory"
* Security track record
* Feasibility of underpinnings (language and constructs), esp. over long-term
* Specific "must-have" functions/requirements
* Your workflow (and more...)


"MVC"
====================================

* Model-View-Controller design provides for separation of functions and better organization.

* MVC frameworks typically rely on "OOP" (Object-Oriented Programming) constructs.

* Frameworks often interact with data through Object-Relational Mapping (ORM) to relational databases.

A few popular MVC frameworks
====================================

* Ruby: Ruby on Rails (RoR)
  - [rubyonrails.org](http://rubyonrails.org)
  - The original, popular web framework. Complex.

* Python: Django
  - [djangoproject.com](http://djangoproject.com)
  - Newer. Intriguing.

* PHP: CakePHP
  - [cakephp.org](http://cakephp.org)
  - Easier to set up. What we'll demo.

* Many, many more ([a comparison](http://en.wikipedia.org/wiki/Comparison_of_web_application_frameworks))

Some important CakePHP characteristics
====================================

* MVC
* Object Oriented traits
* DRY - Don't Repeat Yourself
  - inheritance, plugins, helpers, behaviors
* CoC - Convention over Configuration

Examples:

- Tables are plural (people)
- Reference is singular (person)
- Foreign keys always reference "reference_id"
- Pre-ordained file structure


Implications for further use
====================================

* Need multi-user access "by tommorrow"? 
* Need app security (role based access, encryption)?
* Is this your job (app development can become "full-time")?
* Can you cope with the fine print (code)?
* Are you creating a legacy (that others can mantain)?
