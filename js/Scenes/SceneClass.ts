/*				SCENECLASS.JS
	HAND-MADE JAVASCRIPT CLASS CONTAINING THE API OF A GENERIC SCENE

	DEPENDENCIES :
		- ModuleClass.js
		- Main.js
		- Connect.js
*/
/// <reference path="../Connect.ts"/>
/// <reference path="../Modules/ModuleClass.ts"/>
/// <reference path="../Connect.ts"/>
/// <reference path="../webaudio-asm-wrapper.d.ts"/>
/// <reference path="../Main.ts"/>
/// <reference path="../App.ts"/>


"use strict";



class Scene {

    parent: App;
    isMute: boolean = false;
    //-- Audio Input/Output
    fAudioOutput: ModuleClass;
    fAudioInput: ModuleClass;
    //-- Modules contained in the scene
    private fModuleList: ModuleClass[] = [];
    //-- Graphical Scene container
    sceneView: SceneView;
    static sceneName: string = "Patch";
    isInitLoading: boolean = true;
    eventEditAcc: (event: Event) => void;

    


    constructor(identifiant: string, parent: App, /*onload?: (s: Scene) => void, onunload?: (s: Scene) => void, */sceneView?: SceneView) {
        this.parent = parent;

        this.sceneView = new SceneView();
        this.sceneView.initNormalScene(this)
        this.integrateSceneInBody();
        this.integrateOutput();

    }
   /******************CALLBACKS FOR LOADING/UNLOADING SCENE **************/

    private onload(s: Scene) { }
    private onunload(s: Scene) { }


    getSceneContainer(): HTMLDivElement { return this.sceneView.fSceneContainer; }

    /************************* SHOW/HIDE SCENE ***************************/
    showScene(): void { this.sceneView.fSceneContainer.style.visibility = "visible"; }
    hideScene(): void { this.sceneView.fSceneContainer.style.visibility = "hidden"; }
    /*********************** LOAD/UNLOAD SCENE ***************************/
    loadScene(): void {
        this.onload(this);
    }
    unloadScene():void {
        this.onunload(this)
    }
    /*********************** MUTE/UNMUTE SCENE ***************************/
    muteScene(): void {
        var out: IHTMLDivElementOut = <IHTMLDivElementOut>document.getElementById("audioOutput");
        
        if (out != null) {
            if (out.audioNode.context.suspend != undefined) {//because of Edge not supporting audioContext.suspend() yet
                out.audioNode.context.suspend();
                this.isMute = true;
                this.getAudioOutput().moduleView.fInterfaceContainer.style.backgroundImage = "url(img/ico-speaker-mute.png)"
            }
        }
    }
    unmuteScene(): void {
        console.log("timeIn");
        window.setTimeout(() => { this.delayedUnmuteScene() }, 1000)
    }

    delayedUnmuteScene() {//because of probable Firefox bug with audioContext.resume() when resume to close from suspend
        console.log("timeout")
        var out: IHTMLDivElementOut = <IHTMLDivElementOut>document.getElementById("audioOutput");

        if (out != null) {
            if (out.audioNode.context.resume != undefined) {//because of Edge not supporting audioContext.resume() yet
                out.audioNode.context.resume();
                this.isMute = false;
                this.getAudioOutput().moduleView.fInterfaceContainer.style.backgroundImage = "url(img/ico-speaker.png)"

            }
        }
    }
    //add listner on the output module to give the user the possibility to mute/onmute the scene
    addMuteOutputListner(moduleOutput: ModuleClass) {
        moduleOutput.moduleView.fModuleContainer.ondblclick = () => {
            if (!this.isMute) {
                this.muteScene()
            } else {
                this.unmuteScene()
            }
        }
    }
    /******************** HANDLE MODULES IN SCENE ************************/
    getModules(): ModuleClass[] { return this.fModuleList; }
    addModule(module: ModuleClass): void { this.fModuleList.push(module); }
    removeModule(module: ModuleClass, scene: Scene): void {
        scene.fModuleList.splice(scene.fModuleList.indexOf(module), 1);

    }
	
    private cleanModules():void {
        for (var i = this.fModuleList.length - 1; i >= 0; i--) {
            this.fModuleList[i].deleteModule();
            this.removeModule(this.fModuleList[i],this);
        }
    }
    /*******************************  PUBLIC METHODS  **********************************/
    private deleteScene():void {
        this.cleanModules();
        this.hideScene();
        this.muteScene();
    }
    
    integrateSceneInBody(): void {
        document.body.appendChild(this.sceneView.fSceneContainer);
    }

    /*************** ACTIONS ON AUDIO IN/OUTPUT ***************************/
    integrateInput() {
        var positionInput: PositionModule = this.positionInputModule();
        this.fAudioInput = new ModuleClass(App.idX++, positionInput.x, positionInput.y, "input", this, this.sceneView.inputOutputModuleContainer, this.removeModule);
        var scene: Scene = this;
        this.parent.compileFaust("input", "process=_,_;", positionInput.x, positionInput.y, (factory)=>{ scene.integrateAudioInput(factory) });
        
    }
    integrateOutput() {
        var positionOutput: PositionModule = this.positionOutputModule();
        var scene: Scene = this;
        this.fAudioOutput = new ModuleClass(App.idX++, positionOutput.x, positionOutput.y, "output", this, this.sceneView.inputOutputModuleContainer, this.removeModule);
        this.addMuteOutputListner(this.fAudioOutput);
        this.parent.compileFaust("output", "process=_,_;", positionOutput.x, positionOutput.y, (factory) =>{ scene.integrateAudioOutput(factory) });
        
    }

    private integrateAudioOutput(factory: Factory): void {
        
        if (this.fAudioOutput) {
            this.fAudioOutput.moduleFaust.setSource("process=_,_;");
            this.fAudioOutput.createDSP(factory);
            this.parent.activateAudioOutput(this.fAudioOutput);
        }
        this.fAudioOutput.addInputOutputNodes();
        this.integrateInput();
    }
    private integrateAudioInput(factory: Factory): void {
        if (this.fAudioInput) {
            this.fAudioInput.moduleFaust.setSource("process=_,_;");
            this.fAudioInput.createDSP(factory);
            this.parent.activateAudioInput(this);
        }
        this.fAudioInput.addInputOutputNodes();
        App.hideFullPageLoading();
        this.isInitLoading = false;
    }

    getAudioOutput(): ModuleClass { return this.fAudioOutput; }
    getAudioInput(): ModuleClass { return this.fAudioInput; }
     


    /*********************** SAVE/RECALL SCENE ***************************/
    ///////////////////////////////////////////////////
    //not used for now and not seriously typescripted//
    ///////////////////////////////////////////////////

    private saveScene():string {

        for (var i = 0; i < this.fModuleList.length; i++) {
            this.fModuleList[i].patchID = String(i + 1);
        }

        this.fAudioOutput.patchID = String(0);

        var json:string = '{';

        for (var i = 0; i < this.fModuleList.length; i++) {
            if (i != 0)
                json += ',';

            json += '"' + this.fModuleList[i].patchID.toString() + '":['

            json += '{"x":"' + this.fModuleList[i].moduleView.getModuleContainer().getBoundingClientRect().left + '"},';
            json += '{"y\":"' + this.fModuleList[i].moduleView.getModuleContainer().getBoundingClientRect().top + '"},';
            json += '{"name\":"' + this.fModuleList[i].moduleFaust.getName() + '"},';
            json += '{"code":' + JSON.stringify(this.fModuleList[i].moduleFaust.getSource()) + '},';

            var inputs: Connector[] = this.fModuleList[i].moduleFaust.getInputConnections();

            if (inputs) {

                json += '{"inputs":[';
                for (var j = 0; j < inputs.length; j++) {
                    if (j != 0)
                        json += ',';

                    json += '{"src":"' + inputs[j].source.patchID.toString() + '"}';
                }
                json += ']},';
            }

            var outputs = this.fModuleList[i].moduleFaust.getOutputConnections();
            if (outputs) {
                json += '{"outputs":[';

                for (var j = 0; j < outputs.length; j++) {
                    if (j != 0)
                        json += ',';

                    json += '{"dst":"' + outputs[j].destination.patchID.toString() + '"}';
                }

                json += ']},';
            }

            var params = this.fModuleList[i].moduleFaust.getDSP().controls();
            if (params) {
                json += '{"params":[';

                for (var j = 0; j < params.length; j++) {
                    if (j != 0)
                        json += ',';

                    json += '{"path":"' + params[j] + '"},';
                    json += '{"value":"' + this.fModuleList[i].moduleFaust.getDSP().getValue(params[j]) + '"}';
                }

                json += ']}';
            }

            json += ']';
        }

        json += '}';
        
        // 	console.log(json);
        return json;
    }

    recallScene(json: string):void {

        this.parent.currentNumberDSP = this.fModuleList.length;
        var data: JSON = JSON.parse(json);
        for (var sel in data) {

            var dataCopy = data[sel];

            var newsel;
            var name: string, code: string, x: number, y: number;

            for (newsel in dataCopy) {
                var mainData = dataCopy[newsel];
                if (mainData["name"])
                    name = mainData["name"];
                else if (mainData["code"])
                    code = mainData["code"];
                else if (mainData["x"])
                    x = mainData["x"];
                else if (mainData["y"])
                    y = mainData["y"];
                else if (mainData["inputs"])
                    this.parent.inputs = mainData["inputs"];
                else if (mainData["outputs"])
                    this.parent.outputs = mainData["outputs"];
                else if (mainData["params"])
                    this.parent.params = mainData["params"];
            }
            this.parent.compileFaust(name, code, x, y, this.createModuleAndConnectIt);
        }
    }
	
    private createModuleAndConnectIt(factory:Factory):void {

        //---- This is very similar to "createFaustModule" from App.js
        //---- But as we need to set Params before calling "createFaustInterface", it is copied
        //---- There probably is a better way to do this !!
        if (!factory) {
            alert(faust.getErrorMessage());
            return;
        }

        var faustModule: ModuleClass = new ModuleClass(App.idX++, this.parent.tempModuleX, this.parent.tempModuleY, window.name, this, document.getElementById("modules"), this.removeModule);
        faustModule.moduleFaust.setSource(this.parent.tempModuleSourceCode);
        faustModule.createDSP(factory);

        if (this.parent.params) {
            for (var i = 0; i < this.parent.params.length; i++) {
                //console.log("WINDOW.PARAMS");
                //console.log(this.parent.params.length);
                if (this.parent.params[i] && this.parent.params[i + 1]) {
                    faustModule.addInterfaceParam(this.parent.params[i]["path"], this.parent.params[i + 1]["value"]);
                    i + 1;
                }
            }
        }

        faustModule.recallInterfaceParams();
        faustModule.createFaustInterface();
        faustModule.addInputOutputNodes();
        this.addModule(faustModule);
	
        // WARNING!!!!! Not right in an asynchroneous call of this.parent.compileFaust
        if (this.parent.inputs) {
            for (var i = 0; i < this.parent.inputs.length; i++) {
                var src = this.getModules()[this.parent.inputs[i]["src"] - 1 + this.parent.currentNumberDSP];
                if (src)
                    var connector: Connector = new Connector();
                connector.createConnection(src, src.moduleView.getOutputNode(), faustModule, faustModule.moduleView.getInputNode());
            }
        }

        if (this.parent.outputs) {
            for (var i = 0; i < this.parent.outputs.length; i++) {
                var dst = this.getModules()[this.parent.outputs[i]["dst"] + this.parent.currentNumberDSP - 1];
                var connector: Connector = new Connector();
                if (this.parent.outputs[i]["dst"] == 0)
                    connector.createConnection(faustModule, faustModule.moduleView.getOutputNode(), this.fAudioOutput, this.fAudioOutput.moduleView.getInputNode());
                else if (dst)
                    connector.createConnection(faustModule, faustModule.moduleView.getOutputNode(), dst, dst.moduleView.getInputNode());
            }
        }
    }

    /***************** SET POSITION OF INPUT OUTPUT MODULE ***************/
    positionInputModule(): PositionModule {
        var position: PositionModule = new PositionModule();
        position.x = 10;
        position.y = window.innerHeight / 2;
        return position
    }
    positionOutputModule(): PositionModule {
        var position: PositionModule = new PositionModule();
        position.x = window.innerWidth - 98;
        position.y = window.innerHeight / 2;
        return position
    }
    positionDblTapModule(): PositionModule {
        var position: PositionModule = new PositionModule();
        position.x = window.innerWidth / 2;
        position.y = window.innerHeight / 2;
        return position
    }
    unstyleNode() {
        var modules = this.getModules();
        modules.push(this.fAudioInput);
        modules.push(this.fAudioOutput);
        for (var i = 0; i < modules.length; i++) {
            if (modules[i].moduleView.fInputNode) {
                modules[i].moduleView.fInputNode.style.border = "none";
                modules[i].moduleView.fInputNode.style.left = "-16px";
                modules[i].moduleView.fInputNode.style.marginTop = "-18px";
            }
            if (modules[i].moduleView.fOutputNode){
                modules[i].moduleView.fOutputNode.style.border = "none";
                modules[i].moduleView.fOutputNode.style.right = "-16px";
                modules[i].moduleView.fOutputNode.style.marginTop = "-18px";
            }
        }
        ModuleClass.isNodesModuleUnstyle = true;

    }


}

