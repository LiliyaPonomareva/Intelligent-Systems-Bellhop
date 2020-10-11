(define (domain Bellhop) 
;����������, ������� ����� ���������� ����� �� ��������� � ������ �������,
;�������� � ��������� ���� � �������.

  (:requirements :strips :typing :negative-preconditions)
  
  (:types
    floor   ;����� 
    room    ;�������, � ����� �������� ������������ ����������
    bag     ;�����, ������� ������ ���� ����������
    robot   ;��� �����-����������
    door    ;����� ����� ���������� ���������, ������� ����� �������, ����� ������
    switch  ;����������� �����
  )

  (:predicates
    (at ?x ?room)       ;� ����� ������� ���������� �������
    (in ?room ?floor)   ;������������ ������ �� ������
    (same ?x ?y)        ;�������� ����, ��� x � y - ��� ���� � �� ��
    (holding ?bag)      ;������ �� ����� �����
    (opened ?door)      ;������� �� ����� � ��������, ����� ������
    (light ?switch)     ;������� �� ����
    (onbag ?robot)      ;���������� ���������� �� ����� (����� �� �� ����� ���������� �� �����������)
    (on ?bag)           ;�� ���� ����� ����� �����
    (empty ?Bellhop)    ;���� ������ �������� (������ not(holding ?bag))
  )
  
  ;��� ����������� ������ ����� ���������
  (:action move
    :parameters (?Bellhop - robot ?from - room ?to - room ?door - door ?floor - floor)
    
    :precondition (and (opened ?door)   ;���������, ��� ������� ����� �������, �� ������� �� �������
    (at ?door ?from) (at ?Bellhop ?from)    ;����� ���������� � ��� �� �������, ��� � �����
    (not (onbag ?Bellhop))  ;����� ��������� ����� �� ������ ������ �� �����
    (not (same ?from ?to))  ;�������, �� ������� �� ��������� � � ������� - �� ���� � �� �� �������
    (in ?from ?floor) (in ?to ?floor))  ;������� ����������� �� ����� �����
    
    :effect (and (not(at ?Bellhop ?from)) (at ?Bellhop ?to) (not (opened ?door))) 
    ;����� ������ �� ����� ������� � ����������� � ������, ����� �� ��� �����������
  )
  
  ;�������� �����
  (:action open
   :parameters (?door - door ?Bellhop - robot ?room - room)
   
   :precondition (and (not (opened ?door))  ;����� �� �������
   (at ?Bellhop ?room) (at ?door ?room)) ;����� � ����� ���������� � ����� �������
   
   :effect (opened ?door) ;�������� �����
  )
  
  ;�������� �����
  (:action pickup
    :parameters (?bag - bag ?Bellhop - robot ?room - room)
    
    :precondition (and (empty ?Bellhop) ;����� �� ������ �����
    (at ?bag ?room) (at ?Bellhop ?room) ;����� � ����� � ����� �������
    (not (onbag ?Bellhop)) ;����� �� ����� �� ���� �����
    (not(on ?bag))) ;�� ���� ����� �� ����� �����
    
    :effect (and (holding ?bag) (not (empty ?Bellhop)) (not(at ?bag ?room))) 
    ;����� ������ �����, ��� ������ �� ������, ����� ������ �� � �������
  )
  
  ;��������� �����
  (:action putdown
    :parameters (?bag - bag ?Bellhop - robot ?room - room)
    
    :precondition (and (holding ?bag) (at ?Bellhop ?room)) 
    ;����� ������ �����, ����� � ������ �������
    
    :effect (and (not (holding ?bag)) (empty ?Bellhop) (at ?bag ?room))
    ;����� �� ������ �����, ���� ������, ����� � ������ �������
  )
  
  ;��������� �����
  (:action switchon
    :parameters (?switch - switch ?Bellhop - robot ?room - room)
    
    :precondition (and (onbag ?Bellhop) ;����� �� �����
    (not (light ?switch))   ;���������� �� �������
    (at ?switch ?room) (at ?Bellhop ?room)) ;����������� � ����� � ����� �������
    
    :effect (light ?switch) ;���������� ����������
  )
  
  ;���������� �����
  (:action switchoff
    :parameters (?switch - switch ?Bellhop - robot ?room - room)
    
    :precondition (and (onbag ?Bellhop) ;����� �� �����
    (light ?switch) ;���������� �������
    (at ?switch ?room) (at ?Bellhop ?room)) ;����� � ����������� � ����� �������
    
    :effect (not(light ?switch)) ;���������� ��������
  )
  
  ;��������� �� �����
  (:action climbup
    :parameters (?Bellhop - robot ?bag - bag ?room - room)
    
    :precondition (and (empty ?Bellhop) ;� ������ ��� ����� � �����
    (at ?Bellhop ?room) (at ?bag ?room) ;����� � ����� � ����� �������
    (not (onbag ?Bellhop)) (not(on ?bag))) ;����� �� �� �����, ����� ��������
    
    :effect (and (onbag ?Bellhop) (on ?bag)) ;����� �� �����, �� ���� ����� �����
  )
    
    ;����� � �����
  (:action climbdown
    :parameters (?Bellhop - robot ?bag - bag ?room - room)
    
    :precondition (and (at ?bag ?room) (at ?Bellhop ?room) ;����� � ����� � ����� �����
    (onbag ?Bellhop) (on ?bag)) ;����� �� ���� �����, �� ���� ����� �����
    
    :effect (and (not (onbag ?Bellhop)) ;����� �� �� �����
    (not(on ?bag)) ;����� ��������
    (at ?Bellhop ?room) ;����� � ��� �� �������
    (at ?bag ?room))    ;����� � ��� �� �������
  )
)
