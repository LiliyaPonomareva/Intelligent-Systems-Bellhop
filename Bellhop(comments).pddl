(define (domain Bellhop) 
;Коридорный, который может перемещать сумки из хранилища в нужные комнаты,
;включать и выключать свет в номерах.

  (:requirements :strips :typing :negative-preconditions)
  
  (:types
    floor   ;этажи 
    room    ;комнаты, в между которыми перемещается коридорный
    bag     ;сумки, которые должны быть перемещены
    robot   ;сам робот-коридорный
    door    ;двери между некоторыми комнатами, которые нужно открыть, чтобы пройти
    switch  ;выключатели света
  )

  (:predicates
    (at ?x ?room)       ;в какой комнате находиться предмет
    (in ?room ?floor)   ;расположение комнат на этажах
    (same ?x ?y)        ;проверка того, что x и y - это одно и то же
    (holding ?bag)      ;держит ли робот сумку
    (opened ?door)      ;открыта ли дверь в коридоре, чтобы пройти
    (light ?switch)     ;включен ли свет
    (onbag ?robot)      ;коридорный находиться на сумке (иначе он не может дотянуться до выключателя)
    (on ?bag)           ;на этой сумке стоит робот
    (empty ?Bellhop)    ;руки робота свободны (вместо not(holding ?bag))
  )
  
  ;все перемещения робота между комнатами
  (:action move
    :parameters (?Bellhop - robot ?from - room ?to - room ?door - door ?floor - floor)
    
    :precondition (and (opened ?door)   ;проверяем, что открыта дверь комнаты, из которой мы выходим
    (at ?door ?from) (at ?Bellhop ?from)    ;дверь находиться в той же комнате, что и робот
    (not (onbag ?Bellhop))  ;чтобы двигаться робот не должен стоять на сумке
    (not (same ?from ?to))  ;комнаты, из которой мы двигаемся и в которую - не одна и та же комната
    (in ?from ?floor) (in ?to ?floor))  ;комнаты расположены на одном этаже
    
    :effect (and (not(at ?Bellhop ?from)) (at ?Bellhop ?to) (not (opened ?door))) 
    ;робот уходит из одной комнаты и оказывается в другой, дверь за ним закрывается
  )
  
  ;открытие двери
  (:action open
   :parameters (?door - door ?Bellhop - robot ?room - room)
   
   :precondition (and (not (opened ?door))  ;дверь не открыта
   (at ?Bellhop ?room) (at ?door ?room)) ;робот и дверь находяться в одной комнате
   
   :effect (opened ?door) ;открытая дверь
  )
  
  ;поднятие сумки
  (:action pickup
    :parameters (?bag - bag ?Bellhop - robot ?room - room)
    
    :precondition (and (empty ?Bellhop) ;робот не держит сумку
    (at ?bag ?room) (at ?Bellhop ?room) ;сумка и робот в одной комнате
    (not (onbag ?Bellhop)) ;робот не стоит на этой сумке
    (not(on ?bag))) ;на этой сумке не стоит робот
    
    :effect (and (holding ?bag) (not (empty ?Bellhop)) (not(at ?bag ?room))) 
    ;робот держит сумку, рук робота не пустые, сумка больше не в комнате
  )
  
  ;опускание сумки
  (:action putdown
    :parameters (?bag - bag ?Bellhop - robot ?room - room)
    
    :precondition (and (holding ?bag) (at ?Bellhop ?room)) 
    ;робот держит сумку, робот в нужной комнате
    
    :effect (and (not (holding ?bag)) (empty ?Bellhop) (at ?bag ?room))
    ;робот не держит сумку, руки пустые, сумка в нужной комнате
  )
  
  ;включение света
  (:action switchon
    :parameters (?switch - switch ?Bellhop - robot ?room - room)
    
    :precondition (and (onbag ?Bellhop) ;робот на сумке
    (not (light ?switch))   ;светильник не включен
    (at ?switch ?room) (at ?Bellhop ?room)) ;выключатель и робот в одной комнате
    
    :effect (light ?switch) ;включенный светильник
  )
  
  ;выключение света
  (:action switchoff
    :parameters (?switch - switch ?Bellhop - robot ?room - room)
    
    :precondition (and (onbag ?Bellhop) ;робот на сумке
    (light ?switch) ;светильник включен
    (at ?switch ?room) (at ?Bellhop ?room)) ;робот и выключатель в одной комнате
    
    :effect (not(light ?switch)) ;светильник выключен
  )
  
  ;взбирание на сумку
  (:action climbup
    :parameters (?Bellhop - robot ?bag - bag ?room - room)
    
    :precondition (and (empty ?Bellhop) ;у робота нет сумки в руках
    (at ?Bellhop ?room) (at ?bag ?room) ;робот и сумка в одной комнате
    (not (onbag ?Bellhop)) (not(on ?bag))) ;робот не на сумке, сумка свободна
    
    :effect (and (onbag ?Bellhop) (on ?bag)) ;робот на сумке, на этой сумке робот
  )
    
    ;спуск с сумки
  (:action climbdown
    :parameters (?Bellhop - robot ?bag - bag ?room - room)
    
    :precondition (and (at ?bag ?room) (at ?Bellhop ?room) ;сумка и робот в одном месте
    (onbag ?Bellhop) (on ?bag)) ;робот на этой сумке, на этой сумке робот
    
    :effect (and (not (onbag ?Bellhop)) ;робот не на сумке
    (not(on ?bag)) ;сумка свободна
    (at ?Bellhop ?room) ;робот в той же комнате
    (at ?bag ?room))    ;сумка в той же комнате
  )
)
