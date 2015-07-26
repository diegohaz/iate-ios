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
    
    
/* Retorna todas as refeicoes salvas no Banco de Dados em ordem decrescente de datas.
 * Retorna um array de Meals, ordenado por datas == ID's, em ordem decrescente.
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
        
        //Ordenar a consulta por timeStamp
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
    
    
/* Salva uma nova refeicao no Banco. Ou atualiza, se já existe ID (== timeStamp)
 *
 * Ao salvar a nova refeicao, é gravada a data (ou timeStamp) do processo (== ID da refeicao).
 */
    func save (meal: Meal)
    {
        // AppDelegate da aplicacao
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Context para salvar/deletar/pesquisar objetos
        let context = appDelegate.managedObjectContext!
        
        // Seta o timeStamp como se fosse o id
        meal.timeStamp = NSDate()
        
        //Salva a meal
        var error : NSError? = nil
        println("salvando a meal")
        
        let ok = context.save(&error)
        println("salvou a meal")
        
        if(!ok){
            println("Erro \(error)")
        }
        
        //println("Meal \(meal.title) salvo com sucesso.")
    }

    
/* Deleta uma refeicao do Banco.
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
    
/* Dado o ano, funcao retorna o vetor com as datas distintas (e completas) das refeicoes. Ordem decrescente.
 * Retorna Array de NSDateComponents - datas distintos em dia, mes e ano.
 * Exemplo 1: "let MealDatesArray = MealDB().getEveryMealDays(2015)"
 * Exemplo 2: "println(daysMealArray[i].day)"
 */
    func getEveryMealDates () -> Array<NSDateComponents>
    {
        
        var array = [NSDateComponents]()
        var meals = [Meal]()
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Meal", inManagedObjectContext: context)
        
        
        var fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        meals = context.executeFetchRequest(fetchRequest, error: nil) as! [Meal]
        
        
        for meal in meals {
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear, fromDate: meal.timeStamp)
            
            let day = components.day
            let month = components.month
            let year = components.year
            
            if( array.count == 0) {
                
                var dateFound = NSDateComponents()
                dateFound.day = day
                dateFound.month = month
                dateFound.year  = year
                
                array.append(dateFound)
                
                
            } else {
                
                if ((day != array[array.count - 1].day) || (month != array[array.count - 1].month) || (year != array[array.count - 1].year)) {
                    
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
    

    
    
    
    

   /*  Funcao comparacao para ordenacao do vetor de Meals
    */
    func acsOrder(meal1: Meal, meal2: Meal) -> Bool {
   
        return meal1.timeStamp.compare(meal2.timeStamp) == .OrderedAscending
    }
    
    

/* Busca refeicoes por data. Ordem crescente.
 * Retorna vetor de Meals em uma data específica (parametro NSDateComponents).
 * Exemplo: "let refeicoes = MealDB().getMealsByDate(MealDatesArray[0]),
 * onde let MealDatesArray = MealDB().getEveryMealDates(2015)" - ver funcao acima.
 */
    func getMealsByDate(data: NSDateComponents) -> Array<Meal>
    {
        // Vetor com as refeicoes procuradas.
        var array = [Meal]()
        
        var meals = [Meal]()
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Meal", inManagedObjectContext: context)
        
        
        var fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
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
            
        } // Fim da construcao do vetor de refeicoes distintas na mesma data.
        
        // Devolve array em ordem crescente por data
        return sorted(array, acsOrder)
        
    }
    
 
}

