//
//  MealDB.swift
//  Meal Timeline
//
//  Created by Leandro Morgado on 7/25/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MealDB {
    
    /* Metodo estatico que cria uma instancia de Meal. E insere o objeto no contexto de persistencia.
    * Para instanciar um objeto Meal use : "MealDB.newInstance()"
    */
    class func newInstance() -> Meal
    {
        // AppDelegate da aplicacao
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Context para salvar/deletar/pesquisar objetos
        let context = appDelegate.managedObjectContext!
        
        var meal = NSEntityDescription.insertNewObjectForEntityForName("Meal", inManagedObjectContext: context) as! Meal
        
        return meal
    }
    
    
    /* Retorna todas as refeicoes salvas no Banco de Dados por ORDEM DECRESCENTE de datas.
    * Exemplo: em qualquer classe faça " let array = MealDB().getMeals()"
    */
    func getMeals() -> Array<Meal>
    {
        // AppDelegate da aplicacao
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Context para salvar/deletar/pesquisar objetos
        let context = appDelegate.managedObjectContext!
        
        // Define a entidade utilizada para a consulta. No caso, a entidade Meal
        let entity = NSEntityDescription.entityForName("Meal", inManagedObjectContext: context)
        
        //Cria a request com os filtros da consulta.
        let request = NSFetchRequest()
        request.entity = entity
        
        //Ordenar a consulta por datas == timeStamp em ORDEM DECRESCENTE.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        //Executa a consulta
        var error : NSError? = nil
        let array = context.executeFetchRequest(request, error: &error)
        
        if (array == nil) {
            
            println("Erro \(error)")
            return [] as Array<Meal>
        }
        
        return array as! Array<Meal>
    }
    
    
    /* Salva uma nova refeicao no Banco. Ou atualiza, se já existe certa data == ID (== timeStamp).
    * Ao salvar a nova refeicao, é gravada a data (ou timeStamp) do processo (== ID da refeicao).
    * Exemplo: "MealDB().save(novaRefeicao)"
    */
    func save (meal: Meal)
    {
        // AppDelegate da aplicacao
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Context para salvar/deletar/pesquisar objetos
        let context = appDelegate.managedObjectContext!
        
        // Seta o timeStamp como se fosse o id
        //meal.timeStamp = NSDate()
        
        //Salva a meal
        var error : NSError? = nil
        println("salvando a meal")
        
        let ok = context.save(&error)
        println("salvou a meal")
        
        if(!ok){
            println("Erro \(error)")
        }
    }
    
    
    /* Deleta uma refeicao do Banco.
    * Exemplo: MealDB().delete(qualquerRefeicao)
    */
    func delete(meal: Meal)
    {
        // AppDelegate da aplicacao
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Context para salvar/deletar/pesquisar objetos
        let context = appDelegate.managedObjectContext!
        
        context.deleteObject(meal)
        
        var error: NSError? = nil
        let ok = context.save(&error)
        
        println("deletou a meal")
        
        if (!ok){
            println("Erro \(error)")
        }
        
    }
    
    /* Retorna vetor com ATE 30 datas distintas (e completas) das refeicoes MAIS RECENTES. Portanto, aqui, datas em ORDEM DECRESCENTE.
    * Exemplo: "let MealDatesArray = MealDB().getEveryMealDates()"
    */
    func getEveryMealDates () -> Array<NSDateComponents>
    {
        
        var array = [NSDateComponents]()
        var meals = [Meal]()
        
        // Preparando o CoreData para ser monitorado.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Meal", inManagedObjectContext: context)
        var fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        // Ordenar a consulta por datas == timeStamp em ORDEM DECRESCENTE.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        // Obendo o vetor de todas as refeicoes cadastradas no Banco.
        meals = context.executeFetchRequest(fetchRequest, error: nil) as! [Meal]
        
        
        // Varrendo o vetor meals.
        for meal in meals {
            
            // Converte NSDate em suas componentes "dia, mes e ano", todos valores inteiros.
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear, fromDate: meal.timeStamp)
            let day = components.day
            let month = components.month
            let year = components.year
            
            // Construindo o vetor de datas. Array de NSDateComponents
            if(array.count == 0) {
                
                var dateFound = NSDateComponents()
                dateFound.day = day
                dateFound.month = month
                dateFound.year  = year
                
                println(dateFound.day)
                
                array.append(dateFound)
                
            } else {
                
                if ((day != array[array.count - 1].day)    ||
                    (month != array[array.count - 1].month) ||
                    (year != array[array.count - 1].year))  {
                        
                        var dateFound = NSDateComponents()
                        dateFound.day = day
                        dateFound.month = month
                        dateFound.year  = year
                        
                        array.append(dateFound)
                }
            }
            
            if (array.count > 30) { break }
            
        }
        
        return array
    }
    
    
    
    /* Busca refeicoes por data de cadastro no Banco. Retorna vetor de Meals por ORDEM CRESCENTE de tempo (horas, minutos e segundos distintos).
    * onde let MealDatesArray = MealDB().getMealsByDate(dataPesquisada)" - ver funcao acima.
    */
    func getMealsByDate(data: NSDateComponents) -> Array<Meal>
    {
        
        var array = [Meal]()
        var meals = [Meal]()
        
        // Preparando o CoreData para ser monitorado.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Meal", inManagedObjectContext: context)
        var fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        // Obendo o vetor de todas as refeicoes cadastradas no Banco.
        meals = context.executeFetchRequest(fetchRequest, error: nil) as! [Meal]
        
        // Monitorando o Banco em busca das refeicoes.
        for meal in meals {
            
            // Converte NSDate para os valores inteiros "day, month e year".
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear, fromDate: meal.timeStamp)
            
            let day = components.day
            let month = components.month
            let year = components.year
            
            // Inicio da construcao do vetor de refeicoes.
            if (day == data.day && month == data.month && year == data.year) {
                
                array.append(meal)
            }
            
        } // Fim da construcao do vetor de refeicoes distintas para uma certa data.
        
        // Devolve array em ORDEM CRESCENTE por data
        return array
        
    }
    
    
    /***************************************************************** FIM DAS FUNCOES DO BANCO LOCAL COREDATE *******************************************************************************/
    
    
}
