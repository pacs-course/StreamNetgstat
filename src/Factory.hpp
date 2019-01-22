#ifndef PACSPROJECT_FACTORY_HPP
#define PACSPROJECT_FACTORY_HPP

#include <map>
#include <vector>
#include <memory>
#include <functional>
#include <stdexcept>
#include <type_traits>
#include <Rcpp.h>

/**
* Factory class
*/

namespace generic_factory{

  /**
  * A generic factory.
  * It is implemented as a Singleton. The compulsory way to
  * access a method is Factory::Instance().method().
  * Typycally to access the factory one does
  * \code
  * auto&  myFactory = Factory<A,I,B>::Instance();
  * myFactory.add(...)
  * \endcode
  */

  template <typename AbstractProduct, typename Identifier, typename Builder=std::function<std::unique_ptr<AbstractProduct> ()>>
  class Factory{

  public:
    /*
    * The container for the rules.
    */
    using AbstractProduct_type = AbstractProduct;

    /*
    * The identifier.
    * We must have an ordering since we use a map with
    * the identifier as key.
    */
    using Identifier_type = Identifier;

    /* The builder type.
    * The default is a function.
    */
    using Builder_type = Builder;

    /*
    * Method to access the only instance of the factory. We use Meyer's trick to istantiate the factory.
    */
    static Factory & Instance();

    /* Get the rule with given name
    * The pointer is null if no rule is present.
    */
    std::unique_ptr<AbstractProduct> create(Identifier const & name) const;

    /*
    * Register the given rule.
    */
    void add(Identifier const &, Builder_type const &);

    /*
    * Returns a list of registered rules.
    */
    std::vector<Identifier> registered()const;

    /*
    * Unregister a rule.
    */
    void unregister(Identifier const & name){ _storage.erase(name);}

    /*
    * Default destructor.
    */
    ~Factory() = default;

  private:
    /**
    * \var typedef std::map<Identifier,Builder_type> Container_type
    * Type of the object used to store the object factory
    */
    typedef std::map<Identifier_type,Builder_type> Container_type;

    /**
    * Constructor made private since it is a Singleton
    */
    Factory() = default;

    /**
    * Copy constructor deleted since it is a Singleton
    */
    Factory(Factory const &) = delete;

    /**
    * Assignment operator deleted since it is a Singleton
    */
    Factory & operator =(Factory const &) = delete;

    /**
    * It contains the actual object factory.
    */
    Container_type _storage;
  };



  template <typename AbstractProduct, typename Identifier, typename Builder>
  Factory<AbstractProduct,Identifier,Builder> &
  Factory<AbstractProduct,Identifier,Builder>::Instance() {
    static Factory theFactory;
    return theFactory;
  }


  template <typename AbstractProduct, typename Identifier, typename Builder>
  std::unique_ptr<AbstractProduct>
  Factory<AbstractProduct,Identifier,Builder>::create(Identifier const & name) const {

    auto f = _storage.find(name); //C++11
    if (f == _storage.end()) {
	     std::string out="Identifier " + name + " is not stored in the factory";
	      throw std::invalid_argument(out);
    }
    else {
	       return std::unique_ptr<AbstractProduct>(f->second());
    }
  }

  template <typename AbstractProduct, typename Identifier, typename Builder>
  void
  Factory<AbstractProduct,Identifier,Builder>::add(Identifier const & name, Builder_type const & func){

    auto f =  _storage.insert(std::make_pair(name, func));
    if (f.second == false)
    throw std::invalid_argument("Double registration in Factory");
  }


  template <typename AbstractProduct, typename Identifier, typename Builder>
  std::vector<Identifier>
  Factory<AbstractProduct,Identifier,Builder>::registered() const {
    std::vector<Identifier> tmp;
    tmp.reserve(_storage.size());
    for(auto i=_storage.begin(); i!=_storage.end();++i)
      tmp.push_back(i->first);
    return tmp;
  }

}


#endif
