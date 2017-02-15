# Pickle

## Scope

This is an extension that adds Pickle testing to Lua modules, that is specs among other types of testing. Lua is part of the Scribunto extension, which can be used on a wiki running the Mediawiki software.

The project is on-going, and as such will be extremely unstable &ndash; it might even trigger a meltdown of your computer. :)

### Identification

The _head_ of the extension is targeted at the _head_ of [Mediawiki](https://www.mediawiki.org/wiki/Download) and the _head_ of [Extension:Scribunto](https://www.mediawiki.org/wiki/Extension:Scribunto). There are made no attempts to make the extension compatible with older versions. The versions can be downloaded from Wikimedias git repository, or from GitHub.

A help portal for users are available at [Mediawiki](https://www.mediawiki.org/wiki/Special:MyLanguage/Help:Pickle).

* [Mediawiki](https://phabricator.wikimedia.org/diffusion/MW/)
  * Wikimedias git repository ```git clone https://gerrit.wikimedia.org/r/p/mediawiki/core.git```
  * GitHubs git repository ```git clone https://github.com/wikimedia/mediawiki.git```
* [MediaWiki-extensions-Scribunto](https://phabricator.wikimedia.org/tag/mediawiki-extensions-scribunto/) / [extension-Scribunto](https://phabricator.wikimedia.org/diffusion/ELUA/)
  * Wikimedias own git repository ```git clone https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Scribunto```
  * Wikimedias GitHub repository ```git clone https://github.com/wikimedia/mediawiki-extensions-Scribunto.git```
* [MediaWiki-extensions-Pickle](https://phabricator.wikimedia.org/tag/mediawiki-extensions-pickle/) / [extension-Pickle](https://phabricator.wikimedia.org/diffusion/EPKL/)
  * Wikimedias own git repository ```git clone https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Pickle```
  * Wikimedias GitHubs repository ```git clone https://github.com/wikimedia/mediawiki-extensions-Pickle.git```
* [Pickle development](https://github.com/jeblad/Pickle)

### System overview

The purpose of this extension is to make it possible to do efficient [continous testing](https://en.wikipedia.org/wiki/Continuous_testing) by detecting whether Lua modules (pages) are holding a "Pickle", whereby the Lua code on those pages can run both in an automatic and a manual mode to verify correct operation of some other related module. This makes it possible to do continuous testing in an environment where new code are not only added as part of [continuous integration](https://en.wikipedia.org/wiki/Continuous_integration), but even developed in the production environment itself.

### Document overview

The document is targeted to those that need a quick overview of the extension at a system level. That is a developer or system maintainer with technical experience. It is not ment as a documentation for the casual user. A end user documentation is available at [Help:Pickle](https://www.mediawiki.org/wiki/Help:Pickle)

For a description of the install procedure check out [Extension:Pickle](https://www.mediawiki.org/wiki/Extension:Pickle)

## Referenced documents

Core documents

* [MediaWiki: Help:Pickle](https://www.mediawiki.org/wiki/Help:Pickle)
* [Mediawiki: Extension:Pickle](https://www.mediawiki.org/wiki/Extension:Pickle)
* [Phabricator: MediaWiki-extensions-Pickle](https://phabricator.wikimedia.org/tag/mediawiki-extensions-pickle/)

Additional documents

* [Wikipedia: Continous testing](https://en.wikipedia.org/wiki/Continuous_testing)
* [Wikipedia: Continous integration](https://en.wikipedia.org/wiki/Continuous_integration)
* [Wikipedia: Continuous delivery](https://en.wikipedia.org/wiki/Continuous_delivery)
* [Wikipedia: Unit testing](https://en.wikipedia.org/wiki/Unit_testing)
* [The RSpec Book](https://pragprog.com/book/achbd/the-rspec-book)
* [RSpec: API documentation](http://rspec.info/documentation/)
* [busted: Elegant Lua unit testing](http://olivinelabs.com/busted/)

## Design decisions

A core design choice was to make the impact on the servers as small as possible. That means not running anything without it being highly likely that the results can be used in further processing. It starts with short circuit on content model, which is available in the title structure, and only then request additional data. Thus the number of modules that should need further inspection should be fairly low, and then the overall load from the extension should be small.

If a relation between a _tester_ (the code testing a module) and a _testee_ (the module being tested) is found, then page properties are used to maintain a page specific state. If that state changes then extension data is set up and later consumed by additional handlers. That makes it possible to create a pluggable system where components can be added and detached as necessary.

Pickle code is written at the site in a similar fashion as other Lua code, the only requirement is that pickle code should be a subpage with a specific name.

The pickle code is assumed to connect with the provided Lua modules, and follows the usual _describe_, _context_, and _it_ ladder. Each of those manipulates _subject_ and _expect_ to set the expected behavior from some subunit within the _testee_. This is fairly similar to how [RSpec](http://rspec.info/documentation/) and [Busted](http://olivinelabs.com/busted/) works.

Core areas of Reliability, Availability, Serviceability/Maintainability, Usability, and Safety ([RAS(U)](https://en.wikipedia.org/wiki/Reliability,_availability_and_serviceability_(computing)), [RAMS](https://en.wikipedia.org/wiki/RAMS)) is assumed to be sufficiently covered. An alternate formulation could be to use availability as the sole composite measure.

* [Availability](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page7) is usually a percentage given by reliability, maintainability, serviceability, performance and security, with a calculation based on agreed service time and downtime. There has been no attempts to calculate such a number for the extension itself.
* [Reliability](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page61) is a measure of how long system can perform its function without interruption, usually given as [MTBF](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page47) or [MTBSI](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page48). There has been no attempts to measure this for the extension itself.
* [Maintainability](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page46) is a measure of how fast a system can be restored to normal operation, usually given as [MTRS](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page=48). There has been no attempts to measure this for the extension itself, but as the extension has extensive testing it is assumed that it should be fairly good.
* [Serviceability](https://en.wikipedia.org/wiki/Serviceability_(computer)) (also _supportability_) is the ability of technical support personnel to install, configure, and monitor computer products, identify exceptions or faults, debug or isolate faults. In this context the ability to support this extension. There has been no attempts to measure this for the extension itself, but as the extension has extensive testing it is assumed that it should be fairly good.
* [Usability](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page=66) is how easily a system can be used. The extension is based upon time-proven techniques from the current interface, and no new types of interactions are defined.
* [Safety](https://en.wikipedia.org/wiki/Safety) &ndash; other than use of a system user for logging purposes, it is not known that any part of the code needs special [safety engineering](https://en.wikipedia.org/wiki/Safety_engineering)

## Architectural design

### Components

At a high level the extension consists of core units to run the tests, to extract and track the state from those tests, and inject the tracked state into the common user interface. In addition there are some support libraries.

To run the tests

* LuaLibrary (PHP, Lua)
  * engine (Lua)
  * extractor (Lua)
  * render (Lua)
  * report (Lua)

To extract and track the state

* ExtractStatus (PHP)
* InvokeSubpage (PHP)

Support libraries

* Strategies (PHP)
* Sublinks (PHP)
* TAP (PHP)
* Observer (PHP)
* TNamedStrategies.php
* TNamedStrategy.php
* util.lua
* Stack.lua

### Concept of execution

The extension interact with the core system through hooks registered in [Hooks.php](https://github.com/jeblad/pickle/blob/master/includes/Hooks.php) especially `Pickle\Hooks::onContentAlterParserOutput()`. This function will track state changes, and set [page properties](https://www.mediawiki.org/wiki/Manual:Page_props_table) and extension data accordingly. Other hooks will then pick up the extension data and act on them, thereby setting [page indicators](https://www.mediawiki.org/wiki/Help:Page_status_indicators), [tracking categories](https://www.mediawiki.org/wiki/Help:Tracking_categories), and do [public logging](https://www.mediawiki.org/wiki/Manual:Logging_to_Special:Log).

The call `Pickle\Hooks::onContentAlterParserOutput()` will also run a call to identify a strategy to invoke the proper subpage ([InvokeSuppage](https://github.com/jeblad/pickle/tree/master/includes/InvokeSubpage)), process the result from that page ([TAP](https://github.com/jeblad/pickle/tree/master/includes/TAP)), and then identify the status from the remaining data ([ExtractStatus](https://github.com/jeblad/pickle/tree/master/includes/ExtractStatus)). The call is set up so it can handle both calls made for the tester (aka the pickle-page) and the testee (aka the ordinary module).

The test itself is run as Lua, and is set up in the `Pickle.setupInterface()` call ([Pickle.lua](https://github.com/jeblad/pickle/blob/master/includes/LuaLibrary/lua/non-pure/Pickle.lua)) by a call from  `Pickle\LuaLibrary::register()` ([LuaLibrary.php](https://github.com/jeblad/pickle/blob/master/includes/LuaLibrary/LuaLibrary.php)).

The tests follows pickle-style, with _describe_, _context_, and _it_. Those will then encapsulate tests, which use _subject_ and _expect_ to verify correct behavior of the module under test. The code for those modules can be found in [engine](https://github.com/jeblad/pickle/tree/master/includes/LuaLibrary/lua/pure/picklelib/engine). The engine will produce [reports](https://github.com/jeblad/pickle/tree/master/includes/LuaLibrary/lua/pure/picklelib/report) which are pure data about the tests. Those reports are then [rendered](https://github.com/jeblad/pickle/tree/master/includes/LuaLibrary/lua/pure/picklelib/render). As of this writing there are three different types of renders. Two of them are plain text renders, one giving a compact style layout and one that giving a full style. The third render creates a web style layout.

Test data can be provided to _describe_, _context_, and _it_ as nearly free form text. The data from the text is [extracted](https://github.com/jeblad/pickle/tree/master/includes/LuaLibrary/lua/pure/picklelib/extractor) and casted into the correct type. The present set of extractors are far from comprehensive, but assumed to be sufficient to make the system functional.

### Interface design

The extension does not provide additional subsystems that can be used by the system (site) as such, but will itself use features from the system. In particular [Category](https://github.com/jeblad/pickle/tree/master/includes/Category), [Indicator](https://github.com/jeblad/pickle/tree/master/includes/Indicator), and [LogEntry](https://github.com/jeblad/pickle/tree/master/includes/LogEntry), will access facilities from Mediawiki. How this is done is described on [Help:Pickle/Tracking categories](https://www.mediawiki.org/wiki/Help:Pickle/Tracking_categories), [Help:Pickle/Page status indicators](https://www.mediawiki.org/wiki/Help:Pickle/Page_status_indicators), and [Help:Pickle/Test status log](https://www.mediawiki.org/wiki/Help:Pickle/Test_status_log).

In addition to facilities used by the extension it is possible to make new site specific testing frameworks as long as it exports TAP-formatted reports. By following the [TAP standard](https://testanything.org/) (it is a _personal standard_, and not a rigid one) the extension can use the new framework as its own. If the call must be changed, possibly also the name of the subpage holding the tests, then the configuration must be adjusted. The configuration section in [extension.json](https://github.com/jeblad/pickle/blob/master/extension.json) would be _InvokeSubpage_.

## Detailed design

The following is in a somewhat logical order.

### InvokeSubpage

The unit finds a strategy for accessing a subpage, where the test has a positive outcome if a given page exist (or should exist) in a correct location. That is a relation between a _testee_ (the module being tested) and a _tester_ (the code testing a module) can be established. If the relation exist, or should exist, then the strategy provide methods for the name of the subpage, and also the question that will be parsed and will then provide the report. When a strategy find a usable relation it will not itself track the relation but leave it to the caller.

The strategies use options from the section `InvokeSubpage` in the extensions own [extension.json](https://github.com/jeblad/pickle/blob/master/extension.json). It is possible to adapt this section to additional entries, typically new ways to invoke the subpage.

The strategy classes are divided into a common [interface](https://github.com/jeblad/pickle/blob/master/includes/InvokeSubpage/AInvokeSubpageStrategy.php) and a [singleton](https://github.com/jeblad/pickle/blob/master/includes/InvokeSubpage/InvokeSubpageStrategies.php), where the singleton is the access point for higher level code. All PHP classes that implements the strategy are implementations of the interface.

### ExtractStatus

The unit finds a strategy for interpreting the report from a subpage, where the test has a positive outcome if a given parser evaluates to true. That is the tests reports are interpreted as TAP-formatted, and according to the given report it can be simplified into a final state. If a state is recognized, then the strategy provide a method for the name of the strategy which is the same as the state. The current (final) state will then be compared to previous state by the caller.

The strategies use options from the section `ExtractStatus` in the extensions own [extension.json](https://github.com/jeblad/pickle/blob/master/extension.json). It is possible to adapt this section to additional entries, typically new states.

The strategy classes are divided into a common [interface](https://github.com/jeblad/pickle/blob/master/includes/ExtractStatus/AExtractStatus.php) and a [singleton](https://github.com/jeblad/pickle/blob/master/includes/ExtractStatus/ExtractStatusStrategies.php), where the singleton is the accesspoint for higher level code. All PHP classes that implements the strategy are implementations of the interface.

### LuaLibrary

This is the main access point for passing data from Mediawiki to Scribunto, with `Pickle\LuaLibrary::register()` and `pickle.setupInterface( opts )` as the main access points. Data is set in `Pickle\LuaLibrary::register()` and passed as the `opts` structure to `pickle.setupInterface( opts )`. By setting the members in the `mw` structure values can be made global within Scribunto.

All values passed through `opts` should come from the configuration in [extension.json](https://github.com/jeblad/pickle/blob/master/extension.json), and not be user provided data.

This subsystem is central to proper operation of the extension.

### engine

This is a set of classes for setting up and running tests. It contains the main rutines to make the frames for _describe_, _context_, and _it_, and the same for _subject_ and _expect_. The first three forms the nouns (the frames) in pickle definitions, while the two last forms the access points for further verification.

Routines for this subsystem has a path from source to sink. This should not create any security issue server side, as data is not passed back without proper filtering. Proper escaping should still be done to avoid messing up the output.

This subsystem is central to proper operation of the extension.

### extractor

This is a set of classes for extracting and casting strings to correct type. It contains a limited set of cast operations, only scalar data types and a Json type that will be casted into a table. It is used for extracting data from descriptions provided to the frames, that is _describe_, _context_, and _it_, and the casted strings will then be provided to the functions used by the frames.

This subsystem is a possible security risk because it casts strings into data. As it does not create functions the risk should be limited. If an extractor is made that casts strings into functions the risk could be higher, but note that this only happens in Lua.

The cast methods does not check for valid boundraries before the cast operation is performed, and it will fail if they are wrong.

This subsystem is central to proper operation of the extension.

### render

This is a set of classes for rendering reports in the proper format. It contains sets of renderers for a specific _style_ and for each _type_ of report. Each style is in a different named folder, with libraries for rendering a specific report (a type) being called the same in all folders. There are three types that covers most of the use cases; [compact](https://github.com/jeblad/pickle/tree/master/includes/LuaLibrary/lua/pure/picklelib/render/compact), [full](https://github.com/jeblad/pickle/tree/master/includes/LuaLibrary/lua/pure/picklelib/render/full), and [vivid](https://github.com/jeblad/pickle/tree/master/includes/LuaLibrary/lua/pure/picklelib/render/vivid). The compact style is for interactive use in the test console. The full style is for text views where it is necessary to include all details, typically for integration with other systems. The vivid style is for use in the parser function.

Routines for this subsystem has paths from source to sink, and should escape text if necessary before it is returned. Still note that this subsystem will only be able to display its output after sanitizion, so there isn't any real security risk only a need to aoid messing up the output.

This subsystem is central to proper operation of the extension.

### report

This is a set of classes for collecting and holding reports. Reports are generated by the engine and holds pure data that will be rendered later on by renders. They should be viewed as data containers only.

This subsystem has paths from source to sink, but should not pose any risk in itself. Proper escaping should be done in the render subsystem.

This subsystem is central to proper operation of the extension.

### Strategies

This is a utility class that holds a number of strategies. Main purpose is to replace the pesky singletons with something that can be easilly tested. Most of the strategies use this as a base class.

This subsystem is central to proper operation of the extension.

### Sublinks

If `pickle-status-current` is set, then a link will be created as a _subtitle_ that points to _Special:Log_ and the proper log entries created for `track/good`, `track/pending`, `track/failing`, `track/missing`, `track/unknown`, and any additional entries that might exist. In the current development version the link is set up to filter on the page only and not anything further. It might be wise to filter on the _module track log_.

No values should be passed directly from source to sink in this subsystem.

This subsystem is decoupled from the rest of the system, and only respond on messages passed as extension data. If necessary the subsystem can be completly removed.

### TAP

A parser to compact a messy and large TAP report into something that is easier to parse repeatedly. This compacted report will maintain the fallback chain, but in its present form it is hardcoded. It could be wise to generalize the form.

No values should be passed directly from source to sink in this subsystem.

This subsystem is central to proper operation of the extension, but it can be removed if necessary.

### Console

The visual design of the test console follows the same idea as the debug console, where a panel is positioned below the usual editor and then extended with Javascript in the browser. It is only the `div` that is added directly from the PHP code, but additional code includes [ext.pickle.console.js](https://github.com/jeblad/pickle/blob/master/modules/ext.pickle.console.js) which creates more of the user interface.

On each click of the button a new report will be rendered, in order and in a compact fashion.

The user interface is created whenever a proper subpage is detected.

### Category

If the `pickle-status-current` extension data is set to a valid state, then it will be passed on to Mediawiki as a [tracking category](https://www.mediawiki.org/wiki/Help:Tracking_categories), and then used in the provided tools for such categories. The names of the tracking categories are formed from message keys created from the name.

The categories are defined trough entries in `Category` from [extension.json](https://github.com/jeblad/pickle/blob/master/extension.json). Only named entries will be acted upon, less the default strategy which has an overridden name. The names the strategies respond to comes from `ExtractStatus` upstream in the pipeline.

There are no direct path from source to sink in the code except for the title object, but this object should be properly handled by the existing system.

This subsystem is decoupled from the rest of the system, and only respond on messages passed as extension data. If necessary the subsystem can be completly removed.

### Indicator

If the `pickle-status-current` extension data is set to a valid state, then it will be passed on to Mediawiki as a [page indicator](https://www.mediawiki.org/wiki/Help:Page_status_indicators), and then used in the provided tools for such indicators. The names of the page indicators are formed from message keys created from the name.

The indicators are defined trough entries in `Indicator` from [extension.json](https://github.com/jeblad/pickle/blob/master/extension.json). Only named entries will be acted upon, less the default strategy which has an overridden name. The names the strategies respond to comes from `ExtractStatus` upstream in the pipeline.

There are no direct path from source to sink in the code except for some fully parsed messages, but that is part of the unprotected and sanitized output and should be properly handled by the existing system.

This subsystem is decoupled from the rest of the system, and only respond on messages passed as extension data. If necessary the subsystem can be completly removed.

### LogEntry

If the `pickle-status-current` extension data is valid and set to a different value from `pickle-status-previous`, then the state change will be passed on to Mediawiki as a [log event](https://www.mediawiki.org/wiki/Help:Log), and then used in the provided tools for such logs. The names of the log entries are formed from message keys created from the name.

The indicators are defined trough entries in `LogEntry` from [extension.json](https://github.com/jeblad/pickle/blob/master/extension.json). Only named entries will be acted upon, less the default strategy which has an overridden name. The names the strategies respond to comes from `ExtractStatus` upstream in the pipeline.

There are no direct path from source to sink in the code except for the title object, but this object should be properly handled by the existing system.

This subsystem is decoupled from the rest of the system, and only respond on messages passed as extension data.

### Observer

This is a system user that will be used for reporting state changes that can't be attributed to a specific user. The scenario is typically that some change has taken place that impact a Lua module, and that module is under test. When a user does something that triggers a rendering of the page, the state change is detected, and then the normal behavior would be to log the change with the active user. This would be rather unpopular, as it would not reflect the real cause of the state change. Instead of using that user an alternate account is used.

The user is defined through its numeric id, the entry `ObserverID` from [extension.json](https://github.com/jeblad/pickle/blob/master/extension.json), which work quite well for a single site. On a multisite setup it is necessary to block name changes.

The user class is a singleton as there should be no more than one instance.

## Requirements traceability

_none_

## Notes

_none_
