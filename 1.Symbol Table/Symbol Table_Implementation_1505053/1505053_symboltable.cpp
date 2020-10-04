#include<bits/stdc++.h>
#include<bits/stdc++.h>
#include<windows.h>
#include<algorithm>
#include<ctime>
#include<cstdio>
#include<cstdlib>


using namespace std;

/*

Sybol info class

it is the type of object
that we store in table




*/

class SymbolInfo{

  public:
  string Name, Type;
  SymbolInfo *Next;
  SymbolInfo(string a, string b)
  {
      Name=a;
      Type=b;
      Next=NULL;
  }


};

/*

this is the table
that store the object



*/
class scopetable{

    public:
    SymbolInfo **Arr;
    scopetable *parentScope;
    int id,no_of_bucket;
    scopetable(int a, scopetable *parent,int bucket)
    {
        id=a;
        parentScope=parent;
        no_of_bucket=bucket;
        Arr=new SymbolInfo*[bucket];
        for(int i=0;i<bucket;i++)
        {
            Arr[i]=NULL;
        }
    }
    int insert(string a, string b,int pos)
    {
        SymbolInfo *Temp=Arr[pos];
        SymbolInfo *T=new SymbolInfo(a,b);
        //printf("1");
        while(Temp!=NULL)
        {
            if(Temp->Name==a)return -1;
            Temp=Temp->Next;
        }
        //printf("1");
        if(Arr[pos]==NULL)
        {
            Arr[pos]=T;
            return 0;
        }
        Temp=Arr[pos];
        int cnt=0;
        while(Temp->Next!=NULL)
        {
            cnt++;
            Temp=Temp->Next;
        }
        Temp->Next=T;
        return cnt;
    }
    int look_up(string a, int pos)
    {
        SymbolInfo *Temp=Arr[pos];
        while(Temp!=NULL)
        {
            if(Temp->Name==a)return 1;
            Temp=Temp->Next;
        }
        //printf("1");
        //if(temp->name==a)return 1;
        return -1;

    }
    int Delete(string a, int pos)
    {
        SymbolInfo *p=Arr[pos];
        if(p==NULL)return -1;
        if(Arr[pos]->Name==a)
        {
            p=Arr[pos]->Next;
            delete Arr[pos];
            Arr[pos]=p;
            return 0;
        }
        SymbolInfo *q=p->Next;
        int cnt=0;
        while(p->Next!=NULL)
        {
            cnt++;
            if(q->Name==a)
            {
                p->Next=q->Next;
                delete q;
                return cnt;
            }
            q=q->Next;
            p=p->Next;
        }
        return -1;
    }
    void PRINT_SCOPE()
    {
            SymbolInfo *p;
        cout<<"ScopeTable # "<<id<<endl;
        for(int i=0;i<no_of_bucket;i++){
            cout<<i<<" -->  ";
            p=Arr[i];
            while(p!=NULL){
                cout<<"< "<<p->Name<<" : "<<p->Type<<" >   ";
                p=p->Next;
            }
            cout<<endl;
        }
    }

};

class symboltable{

public:
    scopetable *Current;
    int Count_ScopeTable,bucket;

    symboltable(int n){
        Current=NULL;
        Count_ScopeTable=0;
        bucket=n;
        Count_ScopeTable++;
        scopetable *p=new scopetable(Count_ScopeTable,Current,bucket);
        p->parentScope=Current;
        Current=p;
    }



    int Hash_Point(string x){
        int Sum=0;
        for(int i=0;i<x.length();i++){
            Sum+=((int)x[i]%bucket);
            Sum=Sum%bucket;
        }
        return Sum;
    }

    void ENTER_SCOPE(){
        Count_ScopeTable++;
        scopetable *p=new scopetable(Count_ScopeTable,Current,bucket);
        p->parentScope=Current;
        Current=p;
        p=NULL;
    }
    void INSERT(string x,string y){
        int pos=Hash_Point(x);
       // printf("  1  ");
        int ans=Current->insert(x,y,pos);


        if(ans==-1){
            cout<<"Can't insert as a variable type with this name is decleared before."<<endl;
        }
        else cout<<"Inserted in ScopeTable# "<<Current->id<<" at position "<<pos<<","<<ans<<endl;
    }
    void EXIT_SCOPE(){
        scopetable *p;
        p=Current->parentScope;
        delete Current;
        Current=p;
    }
    void REMOVE(string x)
    {
        int pos=Hash_Point(x);
        int ans=Current->Delete(x,pos);
        if(ans==-1)cout<<"Not found"<<endl;
        else {
            cout<<"Found in ScopeTable# "<<Current->id<<" at position "<<pos<<","<<ans<<endl;
            cout<<"Deleted entry at "<<pos<<","<<ans<<"from current ScopeTable"<<endl;
        }

    }
    void LOOK_UP(string x)
    {
        int pos=Hash_Point(x);

        int ans=Current->look_up(x,pos);
        //printf(" ans=%d ",ans);
        if(ans==-1)cout<<"Not found"<<endl;
        else {
            cout<<"Inserted in ScopeTable# "<<endl;
        }
    }
    void PRINT_CURRENTSCOPE(){
        Current->PRINT_SCOPE();
    }
    void PRINT_ALLSCOPE()
    {
        scopetable *node=Current;
        while(node!=NULL){
            node->PRINT_SCOPE();
            node=node->parentScope;
        }

    }
};



int main()
{
    int n;
   // freopen("in.txt","r",stdin);
   // freopen("ou.txt","w",stdout);

    cin>>n;
    symboltable *head=new symboltable(n);
    string instruction,identifier,identifier_type;
    //while(!feof(stdin)){
    while(1){
        cin>>instruction;
        if(instruction=="I"){
            cin>>identifier>>identifier_type;
            head->INSERT(identifier,identifier_type);
        }
        else if(instruction=="L"){
            cin>>identifier;
            head->LOOK_UP(identifier);
        }
        else if(instruction=="P"){
            cin>>identifier;
            if(identifier=="C")head->PRINT_CURRENTSCOPE();
            else head->PRINT_ALLSCOPE();
        }
        else if(instruction=="S"){
            head->ENTER_SCOPE();
        }
        else if(instruction=="D"){
            cin>>identifier;
            head->REMOVE(identifier);
        }
        else if(instruction=="E"){
            head->EXIT_SCOPE();
        }
    }


}
