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
 *
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
    
    
/* Retorna todas as refeicoes salvas no Banco de Dados.
 * 
 * Retorna um array de Meals, ordenado por datas == ID's, em ordem crescente.
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
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)
        let sortDescriptors = [sortDescriptor]
        
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
    
/* Dado o mes e o ano, retorna vetor com os dias distintos das refeicoes.
 * Retorna Array de inteiros - dias distintos das refeicoes cadastradas ate entao.
 * Exemplo de uso em outras classes: "let daysMealArray = MealDB().getEveryMealDays(7, ano: 2015)"
 */
    func getEveryMealDays (mes: Int, ano: Int) -> Array<Int>
    {
        // Vetor com dias das refeicoes em um mes e ano especificos.
        var array = [Int]()
        
        // Monitorando o Banco em busca das refeicoes desejadas
        for(var i = 0; i < getMeals().count; i++) {
            
            // Converte NSDate para os valores inteiros "day, month e year".
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear, fromDate: getMeals()[i].timeStamp)
            
            let day = components.day
            let month = components.month
            let year = components.year
            
            // Construindo o vetor de dias das refeicoes cadastradas no Banco.
            if( array.count == 0) {
                
                if (month == mes && year == ano) {
                    
                    array.append(day)
                }
                
            } else {
                
                if (month == mes && year == ano && day != array[array.count - 1]) {
                    
                    array.append(day)
                    
                }
            }
            
        } // Vetor dos dias das refeicoes pronto.
        
        return array
        
    }



/* Busca refeicoes por data. 
 * Retorna vetor de Meals em uma data específica (os parametros sao valores inteiros).
 * Exemplo de uso em outras classes: "let refeicoes = MealDB().getMealsByDate(26, mes: 8, ano: 2015)"
 */
    func getMealsByDate(dia: Int, mes: Int, ano: Int) -> Array<Meal>
    {
        // Vetor com as refeicoes procuradas.
        var array = [Meal]()
        
        // Monitorando o Banco em busca das refeicoes desejadas
        for(var i = 0; i < getMeals().count; i++) {
            
            // Converte NSDate para os valores inteiros "day, month e year".
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear, fromDate: getMeals()[i].timeStamp)
            
            let day = components.day
            let month = components.month
            let year = components.year
            
            // Construindo o vetor de refeicoes procurado.
            if (day == dia && month == mes && year == ano) {
                
                array.append(getMeals()[i])
            }
            
        } // Vetor das refeicoes procuradas pronto.
        
        return array
        
    }
    
 
}

