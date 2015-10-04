//
//  EmulatorCore.swift
//  DeltaCore
//
//  Created by Riley Testut on 3/11/15.
//  Copyright (c) 2015 Riley Testut. All rights reserved.
//

public class EmulatorCore: DynamicObject, GameControllerReceiverType
{
    //MARK: - Properties -
    /** Properties **/
    public let game: GameType
    public private(set) var gameViews: [GameView] = []
    public var gameControllers: [GameControllerType] {
        get
        {
            return Array(self.gameControllersDictionary.values)
        }
    }
    
    //MARK: - Private Properties
    private var gameControllersDictionary: [Int: GameControllerType] = [:]

    //MARK: - Initializers -
    /** Initializers **/
    public required init(game: GameType)
    {
        self.game = game
        
        super.init(dynamicIdentifier: game.typeIdentifier, initSelector: Selector("initWithGame:"), initParameters: [game])
    }
    
    /** Subclass Methods **/
    /** Contained within main class declaration because of a Swift limitation where non-ObjC compatible extension methods cannot be overridden **/
    
    //MARK: - GameControllerReceiver -
    /// GameControllerReceiver
    public func gameController(gameController: GameControllerType, didActivateInput input: InputType)
    {
        // Implemented by subclasses
    }
    
    public func gameController(gameController: GameControllerType, didDeactivateInput input: InputType)
    {
        // Implemented by subclasses
    }
    
    //MARK: - Input Transformation -
    /// Input Transformation
    public func inputsForMFiExternalControllerInput(input: InputType) -> [InputType]
    {
        return []
    }
    
    public func addGameView(gameView: GameView)
    {
        self.gameViews.append(gameView)
    }
    
    public func removeGameView(gameView: GameView)
    {
        if let index = self.gameViews.indexOf(gameView)
        {
            self.gameViews.removeAtIndex(index);
        }
    }
}

//MARK: - Emulation -
/// Emulation
public extension EmulatorCore
{
    func startEmulation()
    {
        
    }
    
    func stopEmulation()
    {
        
    }
}

//MARK: - Game Views -
/// Game Views
public extension EmulatorCore
{
    
}

//MARK: - Controllers -
/// Controllers
public extension EmulatorCore
{
    func setGameController(gameController: GameControllerType?, atIndex index: Int) -> GameControllerType?
    {
        let previousGameController = self.gameControllerAtIndex(index)
        previousGameController?.playerIndex = nil
        
        gameController?.playerIndex = index
        gameController?.addReceiver(self)
        self.gameControllersDictionary[index] = gameController
        
        if let gameController = gameController as? MFiExternalController where gameController.inputTransformationHandler == nil
        {
            gameController.inputTransformationHandler = inputsForMFiExternalControllerInput
        }
        
        return previousGameController
    }
    
    func removeAllGameControllers()
    {
        for controller in self.gameControllers
        {
            if let index = controller.playerIndex
            {
                self.setGameController(nil, atIndex: index)
            }
        }
    }
    
    func gameControllerAtIndex(index: Int) -> GameControllerType?
    {
        return self.gameControllersDictionary[index]
    }
}

