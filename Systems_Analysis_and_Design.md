Data Management
========================================================

For Scientific Research

[//]: # (author: Brian High, UW DEOHS)
[//]: # (date: 2014-04-17)
[//]: # (license: CC0 1.0 Universal,linked-content/images)
[//]: # (note: License does not apply to external content such as quoted material, linked web pages, images, or videos. These are licensed separately by their authors, publishers or other copyright holders. See attribution links for details.)
[//]: # (note: Any of the trademarks, service marks, collective marks, design rights, personality rights, or similar rights that are mentioned, used, or cited in the chapters and appendices of the Structured Anaylsis Wiki are the property of their respective owners.)
[//]: # (homepage: https://github.com/brianhigh/data-workshop)

<p style="width: 600px; float: right; clear: right; margin-bottom: 5px; margin-left: 10px; text-align: right; font-weight: bold; font-size: 14pt;"><img src="http://www.stanza.co.uk/body/stanza_+BODY-copy.jpg" alt="stanza body copy" style="padding-bottom:0.5em;" />Photo: &copy; <a href="http://www.stanza.co.uk/body/index.html">Stanza</a>. Used with permission.</p>

Session 3: Systems Analysis and Design
========================================================

![systems analysis and design](images/analysis_and_design.png)

Systems Development Life Cycle
==================================

| Phase | Purpose |
| ----- | ------- |
Preliminary analysis | Define purpose, scope, options, costs |
Systems analysis | Map processes, define requirements |
Systems design | Precise description of modular system |
Development | Build the working system from the design |
Integration and testing | Make sure system works |
Acceptance, installation, deployment | Put system to real use |
Maintenance | Keep system running properly |
Evaluation | Make sure system is serving its purpose |
Disposal | Remove system when no longer needed |

(Source: [Wikipedia](http://en.wikipedia.org/wiki/Systems_development_life-cycle))


An Example Research Project
==================================

Let's imagine that we are to conduct a study like this:
 
* We will sample various surfaces for bacteria.
* Some of those surfaces will be on human subjects.
* We will analyze the bacteria samples in the lab.
* Test results will be entered into a data system.
* We will perform statistical analyses on the data. 

Goals List
===================================

Stakeholder goals for system, in "verb noun" form:

| Role | Goal |
| ---- | ---- |
| Subject | Sign Consent Form  |
| Sampler | Collect Consent Form  |
| Subject | Complete Subject Form  |
| Sampler | Collect Subject Form  |
| Sampler | Collect Sample  |
| Sampler | Deliver Sample |
| Lab Tech | Test Sample  |
| Lab Tech | Dispose Sample |
| Statistician | Analyze Results |

Structured Narrative: Part 1, Subject Data
====================================

| Actor | Use Case | Structured Narrative | 
| ----- | -------- | -------------------- |
| Subject | Sign Consent Form  | If a human subject is sampled, the subject must sign a consent form. |
| Sampler | Collect Consent Form | The sampler must collect the consent form before sampling the subject. |
| Subject | Complete Subject Data Form | The subject must complete a subject data form by providing personal information. |

Structured Narrative: Part 2, Sampling
====================================

| Actor | Use Case | Structured Narrative | 
| ----- | -------- | -------------------- |
| Sampler | Enter Subject Data | The sampler must enter subject information into the system for each human subject sampled. |
| Sampler | Collect Sample  | The sampler may collect a sample from a human subject or from a non-human surface. |
| Sampler | Record Geo Location | The sampler must record the geographical sampling location for all samples taken. |
| Sampler | Record Body Location | The sampler must record the human body sampling location for all samples taken from human subjects. |
| Sampler | Record Temperature | The sampler must record a temperature reading for all samples taken. |
| Sampler | Record Humidity | The sampler must record a humidity reading for all samples taken. |
| Sampler | Enter Sample Data | The sampler must enter sample information into the system for each sample collected. |
| Sampler | Deliver Sample | The sampler must deliver the sample to the laboratory. |

Structured Narrative: Part 3, Analysis
====================================

| Actor | Use Case | Structured Narrative | 
| ----- | -------- | -------------------- |
| Lab Tech | Receive Sample | The laboratory technician must receive the sample when it is delivered. |
| Lab Tech | Store Sample | The laboratory technician must store the sample in a cooler (refrigerator). |
| Lab Tech | Split Sample | The laboratory technician must split the sample before testing. |
| Lab Tech | Test Sample  | The laboratory technician must test the sample before it expires. |
| Lab Tech | Enter Test Result  | The laboratory technician must enter the test result into the system. |
| Lab Tech | Dispose Sample | The laboratory technician must dispose of the sample after it is no longer needed. |
| Statistician | Query Results | The statistician may query the system for test results. |
| Statistician | Analyze Results | The statistician may analyze the results using statistical tools. |


Use Case Diagrams: Project Overview
====================================

This diagram shows the actors and their project goals.

![Project Overview Use Case Diagram](images/Lab_Data_System_Use_Case_Diagram_uc1_v2.png)


Use Case Diagrams: More Detailed View
====================================

This diagram shows a more detailed view of the actors and their project goals.

![More Detailed Use Case Diagram](images/Lab_Data_System_Use_Case_Diagram_uc2_v2.png)

Flow Charts
====================================

To better elucidate process branching in a system, we can use a flow chart. Here is a closer look at the sampling process. 

![Flow Chart](images/Sampling_Data_Entry_Flow_Chart.png)

Swim Lane Diagrams
====================================

This swim lane diagram shows an overview of the system. The lanes not only show actors, but also sequence and outputs.

![Swim Lane Diagram](images/Lab_Data_System_Swim_Lane_Diagram_v2.png)


Data Flow Diagrams
====================================

Context Diagrams (Level 0)

* [Context Diagram with Gane/Sarson Symbols](images/Lab_Data_System_Context_Diagram_Gane.png)
* [Context Diagram with Yourdon/DeMarco Symbols](images/Lab_Data_System_Context_Diagram_Yourdon_Angled_Lines.png)
* [Context Diagram with Yourdon/DeMarco Symbols and Curved Lines](images/Lab_Data_System_Context_Diagram_Yourdon_V1.png)
* [Context Diagram with Yourdon/DeMarco Symbols and Curved Lines without Subject Entity](images/Lab_Data_System_Context_Diagram_Yourdon_V2.png)

Data Flow Diagrams (Level 1 and higher)

* [Level 1 Data Flow Diagram](images/Lab_Data_System_Level_1_DFD_v1.png)
* [Level 1 Data Flow Diagram without Subject Entity](images/Lab_Data_System_Level_1_DFD_Yourdon_v2.png)


Context Diagram: Gane/Sarson Symbols
====================================

![Context Diagram with Gane/Sarson Symbols](images/Lab_Data_System_Context_Diagram_Gane.png)

Using Yourdon/DeMarco Symbols
====================================

![Context Diagram with Yourdon/DeMarco Symbols](images/Lab_Data_System_Context_Diagram_Yourdon_Angled_Lines.png)

Yourdon/DeMarco with Curved Lines
====================================

![Context Diagram with Yourdon/DeMarco Symbols and Curved Lines](images/Lab_Data_System_Context_Diagram_Yourdon_V1.png)

Context Diagram: Without Subject Entity
====================================

![Context Diagram with Yourdon/DeMarco Symbols and Curved Lines without Subject Entity](images/Lab_Data_System_Context_Diagram_Yourdon_V2.png)

Level 1 Data Flow Diagram
====================================

![Level 1 Data Flow Diagram](images/Lab_Data_System_Level_1_DFD_v1.png)


Level 1 DFD ... Without Subject Entity
====================================

![Level 1 Data Flow Diagram without Subject Entity](images/Lab_Data_System_Level_1_DFD_Yourdon_v2.png)


Hands-on Group Exercise
========================================================

Working as a group, ... for your project.

<p style="width: 640px; float: left; clear: right; margin-bottom: 5px; margin-left: 10px; text-align: right; font-weight: bold; font-size: 14pt;"><img src="http://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Group_visioning_session_-_group_one_-_Stierch.jpg/640px-Group_visioning_session_-_group_one_-_Stierch.jpg" alt="group" style="padding-bottom:0.5em;" />Photo: <a href="http://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Group_visioning_session_-_group_one_-_Stierch.jpg/640px-Group_visioning_session_-_group_one_-_Stierch.jpg">SarahStierch / Wikimedia</a></p>

Discussion
========================================================

We will discuss your ....

<p style="width: 275px; float: left; clear: right; margin-bottom: 5px; margin-left: 10px; text-align: right; font-weight: bold; font-size: 14pt;"><img src="http://upload.wikimedia.org/wikipedia/commons/e/eb/User_journey_discussion.png" alt="discussion" style="padding-bottom:0.5em;" />Graphic: <a href="http://upload.wikimedia.org/wikipedia/commons/e/eb/User_journey_discussion.png">Jagbirlehl / Wikimedia</a></p>

In the Coming Sessions...
========================================================

* Entity-Relationship Diagrams
* MySQL Workbench
* Building Database Tables
* Database Applications

Action Items (videos, readings,  and tasks)
========================================================

<table>
   <tr border=0>
      <td width="128" valign="middle"><img width="128" height="128" alt="watching" src="images/watching.jpg">
      </td>
      <td valign="middle">
         <ul>
            <li>
            <li>
            <li>        
            <li>
         </ul>
      </td>
   </tr>
   <tr>
      <td width="128" valign="middle"><img width="128" height="128" alt="readings" src="images/reading.jpg">
      </td>
      <td valign="middle">
         <ul>
            <li>
            <li>
            <li>
            <li>
         </ul>
      </td>
   </tr>
   <tr>
      <td width="128" valign="middle"><img width="128" height="128" alt="tasks" src="images/tasks.jpg"></td>
      <td valign="middle">
         <ul>
            <li> 
            <li>
            <li>
            <li>
         </ul>
      </td>
   </tr>
</table>


See Also
========================================================



Questions and Comments 
========================================================

<p style="width: 380px; float: right; clear: right; margin-bottom: 5px; margin-left: 10px; text-align: right; font-weight: bold; font-size: 14pt;"><img src="http://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Happy_Question.svg/380px-Happy_Question.svg.png" alt="question" style="padding-bottom:0.5em;" />Image: <a href=http://commons.wikimedia.org/wiki/File:Happy_Question.svg">© Nevit Dilmen</a> / Wikimedia</p>


Some Parting Words
========================================================


