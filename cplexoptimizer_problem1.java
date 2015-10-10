
package kapgelproject;

import ilog.concert.*;
import ilog.cplex.*;

public class KapgelProject {

    public static void main(String[] args) {
        model();
    }
    
    
    public static void model(){
        try{
            IloCplex cplex = new IloCplex();
            
            //Variables
            IloNumVar x = cplex.numVar(0, Double.MAX_VALUE, "x");
            IloNumVar y = cplex.numVar(0, Double.MAX_VALUE, "y");
            //Expressions
            IloLinearNumExpr objective = cplex.linearNumExpr();
            objective.addTerm(0.12, x);
            objective.addTerm(0.13, y);
            
            //define objective
            cplex.addMinimize(objective);
            
            //define constraints
            cplex.addGe(cplex.sum(cplex.prod(60, x), cplex.prod(60, y)), 300);
            cplex.addGe(cplex.sum(cplex.prod(12, x), cplex.prod(6, y)), 36);
            cplex.addGe(cplex.sum(cplex.prod(10, x), cplex.prod(30, y)), 90);
            
            //solve
            
            cplex.solve();
        }
        catch (IloException exc){
            exc.printStackTrace();
                  
        }
    }
}
